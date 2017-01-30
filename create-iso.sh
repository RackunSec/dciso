#!/bin/bash
#
# This script creates the ISO and SquashFS
#  It will be a "hybrid" image that you can put onto USB using disk-damager
#
# Set up colored output:
yc='\033[3;33m' # yc = "yellow color"
nc='\033[0m' # nc = "no color"
wc='\033[1;37m' # white color

myPrintf () { # cut back on code rewrite
 #printf "$wc\xe2\x86\xaf $yc$1$nc\n";
 printf "$wc\xe2\x98\x85 $yc$1$nc\n";
}

# Set up working environment (./binary)
myPrintf "Creating development directories in ./binary"
rm -rf binary # remove old dev files
mkdir -p binary/{live,isolinux} # create a few directories
myPrintf "Copying LINUX to the development directory" # copy over LINUX
cp chroot/boot/vmlinuz-* binary/live/vmlinuz
cp chroot/boot/initrd.img-* binary/live/initrd
myPrintf "Making SquashFS filesystem, this will take some time."

# Create the Squash Filesystem
mksquashfs chroot binary/live/filesystem.squashfs -comp xz -e boot

# copy files from the chroot - 
mkdir /usr/lib/ISOLINUX
cp chroot/usr/lib/ISOLINUX/iso* /usr/lib/ISOLINUX/

# Create the actual IS0
myPrintf "Creating the ISO image, this will take some time."
if [ -f "binary/live/filesystem.squashfs" ];then # filesystem successfully made
 # cp /usr/lib/ISOLINUX/isolinux.bin binary/isolinux/ # ISOLINUX for booting into live ISO
 cp /usr/share/live/build/bootloaders/isolinux/isolinux.bin binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/menu.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/hdt.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/ldlinux.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/libcom32.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/libutil.c32 binary/isolinux/
 cp /usr/lib/syslinux/modules/bios/vesamenu.c32 binary/isolinux/ # for nice boot menu?

 # Create an ISOLinux menu:
 myPrintf "Creating the ISOLINUX configuration file" # this can be scripted to take args later:
 cp isolinux/isolinux.cfg binary/isolinux/ # ISOLINUX is now own directory
 TS=$(date|awk '{gsub(":",".",$4); print $3$4$6}')
 xorriso -as mkisofs -r -J -joliet-long -l -cache-inodes \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -partition_offset 16 \
  -A "Debian Live"  -b isolinux/isolinux.bin -c \
  isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
  -boot-info-table -o wt7-elite-$TS.iso binary
else
 myPrintf "SquashFS not created. Something went wrong. Please see details above"
 exit 1;
fi 

# Create an MD5 checksum
myPrintf "Creating MD5 checksum for your ISO image."
if [ -f "wt7-elite-$TS.iso" ]; then # file exists:
 myPrintf "ISO file wt7-elite-$TS.iso created successfully, generating MD5"
 md5sum wt7-elite-$TS.iso |awk '{print $1}' > wt7-elite-$TS.md5
else # no ISO
 myPrintf "ISO was not created, something went wrong. Please see details above."
 exit 1;
fi # now check for MD5 existence:
if [ -f "wt7-elite-$TS.md5" ];then
 myPrintf "MD5 file wt7-elite-$TS.md5 created successfully."
else
 myPrintf "MD5 file could not be created. Something went wrong. Please try with \"md5sum wt7-elite-$TS.iso\""
 exit 1;
fi
exit 0

