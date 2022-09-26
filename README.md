# Debian Custom ISO Builder
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian: Bullseye. The previous version of these scripts relied on [Live-Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) which is no longer a necessary tool and has been removed due to contrived user complexity. 

```
   _____     ______     __     ______     ______
  /\  __-.  /\  ___\   /\ \   /\  ___\   /\  __ \
  \ \ \/\ \ \ \ \____  \ \ \  \ \___  \  \ \ \/\ \
   \ \____-  \ \_____\  \ \_\  \/\_____\  \ \_____\
    \/____/   \/_____/   \/_/   \/_____/   \/_____/
     Debian Custom ISO Utility
     (c) GNU 2022 - @RackunSec

Usage: ./dciso (args)

Arguments:
  build (RELEASE) - Build the chroot directory.
  clean - Destroys the chroot directory.
  start - Starts a chroot session in ./chroot.
  end - Ends the current chroot session from ./chroot
  init - Performs first time set of of the chroot, should be ran within chroot.
  in-start - Sets up the current chroot session, should be ran within chroot.
  in-end - ends the current chroot session, should be ran within chroot.
  geniso (ISO NAME).iso - Will create an ISO file from ./chroot

```

## Host OS Setup
Begin by creating a fresh VM of the latest version of Debian. Do not install any desktop GUI environments if you plan on developing a desktop environment in your ISO. This will be our "host" system. In your host OS, we need a few tools installed to build out our new custom Debian. You can install these easily using the following command,
```bash
apt install debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools live-build git vim curl dosfstools
git clone https://github.com/RackunSec/debian-custom-iso-builder.git
cd debian-custom-iso-builder
```
Next, run:
```bash
./dciso build (RELEASE) 
```
Where "RELEASE" is the Debian release that you want to customize. E.g.: buster, bullseye, etc. This script will build a `chroot/` directory. Next we need to put a few tool into the chroot to access it while chrooted:

## Chroot Access
Now, simply start the chroot with the following command:
```bash
./dciso start
```
Once within the chroot, run the tool we passed to it with:
```bash
/etc/live-tools/dciso init # installs a lot of stuff
/etc/live-tools/dciso in-start # starts the chroot and mounts stuff for x11
```
## Chroot Customizations
Now, we are ready to begin installing packages and making our customizations. If you install `Xfce4`, you can simply run `startx` from the command line and customize the desktop/menus/etc.
## Exit Chroot
Once completed, run 
```bash
/etc/live-build/dciso in-end
```
and exit the shell with `CTRL+D`.
## Generate the ISO
Finally, generate the ISO file with the following command:
```bash
./dciso geniso (ISO NAME).iso
```
