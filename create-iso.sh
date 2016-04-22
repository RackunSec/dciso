#!/bin/bash
#
# This script creates the ISO and SquashFS
#  It will be a "hybrid" image that you can put onto USB using disk-damager
#
# Set up colored output:
yc='\033[3;33m' # yc = "yellow color"
nc='\033[0m' # nc = "no color"

myPrintf () { # cut back on code rewrite
 printf "$yc$1$nc\n";
}

# Set up working environment (./binary)
printf "Creating development directories in ./binary"
rm -rf binary # remove old dev files
mkdir -p binary/{live,isolinux} # create a few directories
printf "Copying LINUX to the development directory" # copy over LINUX
cp chroot/boot/vmlinuz-4.4.0-1-686-pae binary/live/vmlinuz
cp chroot/boot/initrd.img-4.4.0-1-686-pae binary/live/initrd
printf "Making SquashFS filesystem, this will take some time."

# Create the Squash Filesystem
mksquashfs chroot binary/live/filesystem.squashfs -comp xz -e boot

# Create the actual IS0
printf "Creating the ISO image, this will take some time."
if [ -f "binary/live/filesystem.squashfs" ];then # filesystem successfully made
 cp /usr/lib/ISOLINUX/isolinux.bin binary/isolinux/ # ISOLINUX for booting into live ISO
 cp /usr/lib/syslinux/modules/bios/menu.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/hdt.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/ldlinux.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/libcom32.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/libutil.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/vesamenu.c32 binary/isolinux/ # for nice boot menu?

 # Create an ISOLinux menu:
 printf "Creating the ISOLINUX configuration file" # this can be scripted to take args later:
 cp isolinux/isolinux.cfg binary/isolinux/ # ISOLINUX is now own directory
 TS=$(date|awk '{gsub(":",".",$4); print $3$4$6}')
 xorriso -as mkisofs -r -J -joliet-long -l -cache-inodes \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -partition_offset 16 \
  -A "Debian Live"  -b isolinux/isolinux.bin -c \
  isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
  -boot-info-table -o wt7-elite-$TS.iso binary
else
 printf "SquashFS not created. Something went wrong. Please see details above"
 exit 1;
fi 

# Create an MD5 checksum
printf "Creating MD5 checksum for your ISO image."
if [ -f "wt7-elite-$TS.iso" ]; then # file exists:
 printf "ISO file created successfully, generating MD5"
 md5sum wt7-elite-$TS.iso |awk '{print $1}' > wt7-elite-$TS.md5
else # no ISO
 printf "ISO was not created, something went wrong. Please see details above."
 exit 1;
fi


