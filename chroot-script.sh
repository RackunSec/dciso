#!/bin/bash
# WT7- Building the ISO requires a lot of leg work
#  so I am scripting it.
#
echo "Mounting devices into chroot"
mount --bind /dev  chroot/dev/
mount --bind /dev/pts chroot/dev/pts/
mount --bind /proc chroot/proc/
mount --bind /sys  chroot/sys/
