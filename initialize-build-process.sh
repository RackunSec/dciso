#!/bin/bash
#
# This script will setup the chrooted env to begin customization and should ONLY be
#  ran once at the beginning of the entire development process
lb clean # cleans out ./chroot
lb config
lb build
