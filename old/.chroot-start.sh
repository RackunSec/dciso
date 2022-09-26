#!/bin/bash
# WT7- Building the ISO requires a lot of leg work
#  so I am scripting it.
#
echo "Mounting devices into chroot, when done, you will be chrooted... "
mount --bind /dev ./chroot/dev/
mount --bind /dev/pts ./chroot/dev/pts/
mount --bind /dev/shm ./chroot/dev/shm # REQUIRED
mount --bind /proc ./chroot/proc/
mount --bind /sys  ./chroot/sys/
mount --bind /run ./chroot/run # for x11 mouse and keyboard functioning!
chroot ./chroot
