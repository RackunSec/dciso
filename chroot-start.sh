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


# consider this :
sudo chroot ./chroot

# Here, your are in the chroot of your Debian liveCD
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
export PS1="\e[01;31m(live):\W \$ \e[00m"

# Here the tweak scripts is done !
	dhclient -v # establish the internet connection to this virtual environment.
	
	apt-get install .......

umount /proc /sys /dev/pts
exit
# exit chroot
cd ..

# This is how it looks like to be live :
#
# (live):/ $ mount none -t proc /proc
# (live):/ $ mount none -t sysfs /sys
# (live):/ $ mount none -t devpts /dev/pts
# (live):/ $ export HOME=/root
# (live):/ $ export LC_ALL=C
# (live):/ $ export PS1="\e[01;31m(live):\W \$ \e[00m"
# (live):/ $
# (live):/ $ dhclient -v 
# (live):/ $ sudo apt-get install qtcreator etc. to tweak your debian installation to your needs.
# (live):/ $
# (live):/ $
# (live):/ $ umount /proc /sys /dev/pts
# $ exit

# Reference : https://github.com/Oros42/CustomDebian
