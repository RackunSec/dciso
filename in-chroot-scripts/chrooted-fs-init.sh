#!/usr/bin/env bash
# Run this script only once in the chrooted environment
##
dhclient -v # grab an IP address
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
apt update # if this fails, you need to run the previous script, "in-chroot-mounts.sh"
dbus-uuidgen > /var/lib/dbus/machine-id
# if the locales failed previously, try again now that we have a new uid:
##dpkg-reconfigure locales ## DEBUG
apt update
apt install linux-image-amd64 live-boot systemd-sysv
update-initramfs -u
apt install vim ftp open-vm-* curl git python3-pip xfce4 tilix python3-pip python3 gedit dbus-x11 nmap 
