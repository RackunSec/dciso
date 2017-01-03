#!/bin/bash
#
# Run this AFTER leavin gthe chrooted environment
#  to unmount stuff
echo "Umounting devices in chroot/"
umount {chroot/dev/pts,chroot/dev,chroot/sys,chroot/proc,chroot/run}
