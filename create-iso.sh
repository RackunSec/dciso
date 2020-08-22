#!/bin/bash
# UPDATED for DEMON LINUX using 64 bit OS and GRUB
# This script creates the ISO and SquashFS
#  It will be a "hybrid" image that you can put onto USB using disk-damager
#
# Set up colored output:
yc='\033[3;33m' # yc = "yellow color"
nc='\033[0m' # nc = "no color"
wc='\033[1;37m' # white color
iso_name="generic.iso"

# arg 1 is the name of the ISO
if [[ "$1" == "" ]]
then
	printf "Please specify an ISO name.\n"
	exit 1337
else
	iso_name=$1
fi

myPrintf () { # cut back on code rewrite
 #printf "$wc\xe2\x86\xaf $yc$1$nc\n";
 printf "$wc\xe2\x98\x85 $yc$1$nc\n";
}

###
### Set up working environment (./binary)
myPrintf "Creating development directories in ./binary ... "
rm -rf image 2>/dev/null # remove old dev files
rm -rf scratch 2>/dev/null # remove old versions
mkdir -p {image/live,scratch}

###
### Create SquashFS:
myPrintf "Making SquashFS filesystem, this will take some time ... "
mksquashfs chroot image/live/filesystem.squashfs -comp xz -e boot

###
### Copy the VMLINUZ and INITRD into the ./binary directory:
myPrintf "Copying Kernel and InitRAMFS to the development directory ... " # copy over LINUX
cp chroot/boot/vmlinuz-* image/vmlinuz
cp chroot/boot/initrd.img-* image/initrd

### 
### Copt GRUB Menu over to new image area:
cp grub/grub.cfg scratch/grub.cfg

touch image/DEMON_CUSTOM

#################################
### UEFI/BIOS Booting:

### (step 1)
### Create Grub UEFI/BIOS image:
grub-mkstandalone \
	--format=x86_64-efi \
	--output=scratch/bootx64.efi \
	--locales="" \
	--fonts="" \
	"boot/grub/grub.cfg=scratch/grub.cfg"

### (step 2)
### Create Fat 16 UEFI boot disk image:
(cd scratch && dd if=/dev/zero of=efiboot.img bs=1M count=10 && \
	mkfs.vfat efiboot.img && \
	mmd -i efiboot.img efi efi/boot && \
	mcopy -i efiboot.img ./bootx64.efi ::efi/boot/)

### (step 3)
### Create GRUB BIOS Image:
grub-mkstandalone \
	--format=i386-pc \
	--output=scratch/core.img \
	--install-modules="linux normal iso9660 biosdisk memdisk search tar ls" \
	--modules="linux normal iso9660 biosdisk search" \
	--locales="" \
	--fonts="" \
	"boot/grub/grub.cfg=scratch/grub.cfg"

### (step 4)
### Combine GRUB with our Bootloader IMG:
cat /usr/lib/grub/i386-pc/cdboot.img \
	scratch/core.img \
	> scratch/bios.img

###
### Finally, Generate the ISO Image file:
xorriso \
	-as mkisofs \
	-iso-level 3 \
	-full-iso9660-filenames \
	-volid "DEMON_CUSTOM" \
	-eltorito-boot \
	 boot/grub/bios.img \
	 -no-emul-boot \
	 -boot-load-size 4 \
	 -boot-info-table \
	 --eltorito-catalog boot/grub/boot.cat \
	--grub2-boot-info \
	--grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
	--eltorito-alt-boot \
	 -e EFI/efiboot.img \
	 -no-emul-boot \
	 -append_partition 2 0xef scratch/efiboot.img \
	 -output "$iso_name" \
	 -graft-points \
	   "image" \
	   /boot/grub/bios.img=scratch/bios.img \
	   /EFI/efiboot.img=scratch/efiboot.img

## I mean, what could go wrong ??
