#!/bin/bash
#
# This script will setup the chrooted env to begin customization and should ONLY be
#  ran once at the beginning of the entire development process
if [ -d "./chroot" ]; then
 printf "WARNING!! directory \"chroot\" found.\nIf you continue, all work in \"chroot\" will be LOST.\n\n";
 printf "Continue (y/n)? ";
 read ans;
 if [ "$ans" = "y" ]; then
  rm -rf chroot
  lb clean # cleans out ./chroot
  lb config
  lb build
 else
  printf "Phew! That was a close one!\n";
 fi
else
 printf "Creating \"chroot\" workspace\n";
 lb clean # cleans out ./chroot
 lb config
 lb build
fi
