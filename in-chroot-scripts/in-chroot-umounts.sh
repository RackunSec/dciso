#!/bin/bash
# Run this command after exiting the chroot to build
cp -Rvvv /var/log/postgresql /tmp/
rm /var/log/*
rm /var/log/*/*
rm /var/log/*/*/*
cp -Rvvv /tmp/postgresql /var/log/postgresql
echo "" > /root/.xsession-errors
## get rid of apt-get stuff
apt-get clean
rm /var/lib/apt/lists/ftp*
rm /var/lib/apt/lists/http*
## get rid of stuff from home
rm /root/.bash_history
rm /root/.ssh/known_hosts
rm -rf /root/Downloads/*
rm -rf /root/Desktop/*
rm -rf /root/Videos/*
## Clean up all temp files with BleachBit:
bleachbit
rm /var/lib/dbus/machine-id && rm -rf /tmp/*
umount /proc /sys /dev/pts /dev
exit;
