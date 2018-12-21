#!/bin/bash
# This is part of the new development process and should only be used for Debian 9+
# New for 2019 Debian development
# (C) GNU - WEAKNETLABS 2019, DEMON LINUX, Douglas Berdeaux
WORKINGDIR=demon-dev # This needs to be set in the root, so e.g: "/debianlive"
rsync -a / $WORKINGDIR/debian-custom-iso-scripts/chroot --exclude=/{$WORKINGDIR,lib/live,live,cdrom,mnt,proc,run,sys,media,boot,vmlinuz,vmlinuz.old,initrd.img,initrd.img.old,tmp,lost+found,srv}
