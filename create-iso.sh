#!/bin/bash
echo "Creating development directories in ./binary"
mkdir -p binary/{live,isolinux}
echo "Copying LINUX to the development directory"
cp chroot/boot/vmlinuz-4.4.0-1-686-pae binary/live/vmlinuz
cp chroot/boot/initrd.img-4.4.0-1-686-pae binary/live/initrd
echo "Making SquashFS filesystem, this will take some time."
mksquashfs chroot binary/live/filesystem.squashfs -comp xz -e boot
cp /usr/lib/ISOLINUX/isolinux.bin binary/isolinux/
cp /usr/lib/syslinux/modules/bios/menu.c32 binary/isolinux/
# Create an ISOLinux menu:
echo "Creating the ISOLINUX configuration file" # this can be scripted to take args later:
cat > binary/isolinux/isolinux.cfg << CFG
ui menu.c32
prompt 0
menu title Weakerthan Linux 7 Elite
timeout 300

label wt7-elite-live
 menu label ^Weakerthan Linux 7 Elite - (Live)
 menu default
 linux live/vmlinuz
 append initrd=/live/initrd boot=live persistence quiet
CFG
# Create the ISO with timestamp:
echo "Creating the ISO image, this will take some time."
TS=$(date|awk '{gsub(":",".",$4); print $3$4$6}')
xorriso -as mkisofs -r -J -joliet-long -l -cache-inodes \
 -isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin -partition_offset 16 \
 -A "Debian Live"  -b isolinux/isolinux.bin -c \
 isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
 -boot-info-table -o wt7-elite-$TS.iso binary
# Create an md5 of the ISO:
echo "Craeting MD5 checksum for your ISO image."
md5sum wt7-elite-$TS.iso |awk '{print $1}' > wt7-elite-$TS.md5
