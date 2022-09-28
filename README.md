# Debian Custom ISO Builder
`dciso` is a tool that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian: Bullseye. The previous version of these scripts relied on [Live-Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) which is no longer a necessary tool and has been removed due to contrived user complexity. 

```
 Debian Custom ISO Utility
 (c) GNU 2022 - @RackunSec

Usage: ./dciso (args)

Arguments:
  build (RELEASE) - Build the chroot directory.
  install-dep - Install all dependencies required for dciso.
  clean - Destroys the chroot directory.
  start - Starts a chroot session in ./chroot.
  end - Ends the current chroot session from ./chroot
  init - Performs first time set of of the chroot, should be ran within chroot.
  in-start - Sets up the current chroot session, should be ran within chroot.
  in-end - ends the current chroot session, should be ran within chroot.
  geniso (ISO NAME).iso - Will create an ISO file from ./chroot
```
## Installation
To install, run the following commands:
```bash
git clone https://github.com/RackunSec/debian-custom-iso-builder.git
cd debian-custom-iso-builder
chmod +x dciso
./dciso install-dep # This will install all dependencies
```
## Building your Custom ISO
To build an ISO, we need a chroot to work out of and make our customizations. We build the chroot with the following command:
```bash
./dciso build (RELEASE) 
```
Where "RELEASE" is the Debian release that you want to customize. E.g.: buster, bullseye, etc. This script will build a `chroot/` directory. Next we need to put a few tool into the chroot to access it while chrooted:

### Chroot Access and Customizations
Now, simply start the chroot shell with the following command:
```bash
./dciso start-chroot
```
Once within the chroot shell, run the tool we passed to it with:
```bash
/etc/live-tools/dciso init # installs a lot of stuff
/etc/live-tools/dciso in-start-chroot # starts the chroot and mounts stuff for x11
```
Now, we are ready to begin installing packages and making our customizations. If you install `Xfce4`, you can simply run `startx` from the command line and customize the desktop/menus/etc.
### Exit Chroot
Once completed, run 
```bash
/etc/live-build/dciso in-end-chroot
```
and exit the chroot shell with `CTRL+D`.
## Generate the ISO
Finally, generate the ISO file with the following command:
```bash
./dciso geniso (ISO NAME).iso
```
