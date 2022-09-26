#!/usr/bin/env bash
## Debian Custom ISO Initialization of Chroot
## 2022 @RackunSec
usage () {
  printf "[USAGE] ./dciso_chroot build (RELEASE) # to build the chroot.\n"
  printf "[USAGE] ./dciso_chroot.sh start # to start the chroot.\n"
  printf "[USAGE] ./dciso_chroot.sh end # to end the chroot.\n\n"
  exit 1337
}
if [[ $# -eq 1 ]] ## probably just "start" or "end"
then
  if [[ "$1" == "start" ]] ## start the chroot
  then
    printf "[i] Mounting devices into chroot, when done, you will be chrooted... \n"
    mount --bind /dev ./chroot/dev/
    mount --bind /dev/pts ./chroot/dev/pts/
    mount --bind /dev/shm ./chroot/dev/shm # REQUIRED
    mount --bind /proc ./chroot/proc/
    mount --bind /sys  ./chroot/sys/
    mount --bind /run ./chroot/run # for x11 mouse and keyboard functioning!
    chroot ./chroot
  elif [[ "$1" == "end" ]]
  then
    printf "[i] Umounting devices in ./chroot ... \n"
    umount {chroot/dev/pts,chroot/dev,chroot/sys,chroot/proc,chroot/run}
    printf "[i] Completed. I recommend that you reboot.\n"
  else
    if [ "$1" != "build" ]
    then
      printf "[?] I don't know what ${1} is ... \n"
      usage
    else
      printf "[?] Build what? I need a release name (buster, bullseye, etc).\n"
      usage
    fi
  fi
elif [[ $# -eq 2 ]]
then
  if [[ "$1" == "build" ]]
  then
    printf "[i] Building chroot directory with ${2} ... \n"
    debootstrap --arch=amd64 ${2} chroot
    printf "[i] Copying tools into ./chroot\n"
    mkdir chroot/etc/live-tools
    cp utils/dciso_inside_chroot.sh chroot/etc/live-tools/
    chmod +x chroot/etc/live-tools/
    printf "[i] Completed. Run './dciso_chroot.sh start' to enter chroot.\n"
  fi
else
  printf "[?] I need something to do.\n"
  usage
fi
