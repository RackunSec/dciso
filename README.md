# Debian Custom ISO Builder
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian: Bullseye. The previous version of these scripts relied on [Live-Build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) which is no longer a necessary tool and has been removed due to contrived user complexity. 

## Host OS Setup
Begin by creating a fresh VM of the latest version of Debian. Do not install any desktop GUI environments if you plan on developing a desktop environment in your ISO. This will be our "host" system. In your host OS, we need a few tools installed to build out our new custom Debian. You can install these easily using the following command,
```bash
apt install debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools live-build git vim curl dosfstools
git clone https://github.com/RackunSec/debian-custom-iso-builder.git
cd debian-custom-iso-builder
```
Next, run:
```bash
./dciso_build_chroot.sh (RELEASE) 
```
Where "RELEASE" is the Debian release that you want to customize. E.g.: buster, bullseye, etc. This script will build a `chroot/` directory. Next we need to put a few tool into the chroot to access it while chrooted:
```bash
mkdir chroot/etc/demon/
cp in-chroot.sh chroot/etc/demon
chmod +x chroot/etc/demon/*
```
## Chroot Access
Now, simply start the chroot with the following command:
```bash
./start-chroot.sh
```
Once within the chroot, run the tool we passed to it with:
```bash
/etc/demon/in-chroot.sh init
/etc/demon/in-chroot.sh start
```
## Chroot Customizations
Now, we are ready to begin installing packages and making our customizations. If you install `Xfce4`, you can simply run `startx` from the command line and customize the desktop/menus/etc.
## Exit Chroot
Once completed, run 
```bash
/etc/demon/in-chroot.sh end
```
and exit the shell with `CTRL+D`.
## Generate the ISO
Finally, generate the ISO file with the following command:
```bash
./create-iso (ISO NAME).iso
```
