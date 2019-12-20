#!/bin/bash
# Specify the distribution code name (e.g.: buster, sid, stretch, etc)
# This script will setup the chrooted env to begin customization and should ONLY be
#  ran once at the beginning of the entire development process
if [ "$1" == "" ]
then
 printf "Please give me an argument Debian version, e.g.: buster, squeeze, wheezy\n"
 exit
fi
if [ -d "./chroot" ]; then
 printf "WARNING!! directory \"chroot\" found.\nIf you continue, all work in \"chroot\" will be LOST.\n\n";
 printf "Continue (y/n)? ";
 read ans;
 if [ "$ans" = "y" ]; then
  rm -rf chroot
 else
  printf "Phew! That was a close one!\n";
 fi
fi
# Start the build process:
printf "Creating \"chroot\" workspace\n";
lb clean # cleans out ./chroot
lb config --distribution $1
lb build

