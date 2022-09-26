#!/usr/bin/env bash
## Sets up the chroot environment for creating an ISO
## 2022 @RackunSec

## Get network connection up:
dciso_net () {
  dhclient -v
}
## Usage:
usage () {
  printf "[USAGE]: ./dciso_in_chroot.sh (init|start|end).\n"
  printf "[WARNING]: \"init\" should only be ran once when the chroot was created.\n"
  printf "[USAGE]: ./dciso_in_chroot.sh start # starts the chroot and mounts things.\n"
  printf "[USAGE]: ./dciso_in_chroot.sh end # ends the chroot and unmounts things.\n"
  exit 1337
}
## main()
if [[ "$1" == "init" ]]
  then
    printf "[i] Initialization started\n"
    dciso_net
    ## install initial depends:
    printf "[i] Installing initial dependencies ... \n"
    apt update
    apt install locales systemd-sysv live-boot -y
    ## configure initial depends:
    printf "[i] Configuring initial dependencies ... \n"
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    locale-gen en_US.UTF-8
    dpkg-reconfigure locales
    printf "[i] Generating a new system UUID ... \n"
    dbus-uuidgen > /var/lib/dbus/machine-id
    printf "[i] Installing a new kernel ... \n"
    apt install -y linux-image-amd64 live-boot systemd-sysv
    update-initramfs -u
    printf "[i] Installing customization apps ... \n"
    apt install -y vim ftp open-vm-* curl git xfce4 tilix python3-pip python3 gedit dbus-x11 nmap unzip papirus-icon-theme python3-venv
elif [[ "$1" == "start" ]]
  then
    dciso_net
    printf "[i] Chroot started. [READY]\n"
elif [[ "$1" == "end" ]]
  then
    dciso_net
    printf "[i] Chroot ended. CTRL+D to exit.\n"
else
  usage ## what happened?
fi
