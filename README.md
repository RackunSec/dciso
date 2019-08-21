# Debian Custom ISO Scripts and Tutorial
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian.

## Custom Scripts
This repository should help anyone who is unfamiliar with the process of creating a customized ISO but this is NO MEANS a full tutorial on the subject. This is just how I do it and I have thoroughly tested every step, but in the world of open-source, small changes can destroy a house of cards, so to speak. Please make sure you report errors with logs or terminal output so I can better help troubleshoot any issues that arise during your ISO building. I am making this because I honestly could not find solid, working, up-to-date tutorials anywhere I looked. I could not get Debian's "live-build" working preoperly for the life of me and it just seemed very convoluted. This tutorial and these scripts were designed to work with Debian Stretch. We will be designing our own custom 32bit Debian ISO with the SYSLINUX boot loader. 

I highly recommend looking at the source code of the scripts. They utilize Bash programming, AWK, SED, and Grep and are written with lots of comments. This should help anyone unfamiliar with the process of creating a live ISO, or even installing an ISO to a HDD. First, we will need to initialize the project.

### Dependencies
In your development OS, we need a few tools installed to build out our new Custom Debian. You can install these easily using the following command,
```
root@demon:~# apt install debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amdd64-bin mtools
```

### Initialize the Project
The first part, is simply customizing the Debian ISO, in our case the Weakerthan LINUX flavor. The process is that same for starting from scratch, but you need to run the command:
```
root@demon-dev:~# initialize-build-process.sh buster
``` 
This will install all of the necessary tools to build the ISO and download the Debian LINUX system including packages and system configurations using the `lb` live-build Debian tool. Once this builds the ISO, we can then use the following steps in the "Updating an ISO" section to make our customizations before creating our own ISO.

### Build in Customizations
we now have the directory ```./chroot``` which contains our soon-to-be live ISO OS. We need to biuld a place within the ```./chroot``` directory which will hold our "in chroot scripts" like so,
```
root@demon-dev:~# mkdir chroot/demon-dev
root@demon-dev:~# cp in-chroot-scripts/* chroot/demon-dev
```
Now, we can change root (chroot) into our new ```./chroot``` directory and run the ```/demon-dev/in-chroot-mounts.sh``` script to prepare our environment for customizations. To begin, we simply need to run the following command to change root into the ```./chroot``` directory and once done, run the ```/demon-dev/in-chroot-mounts.sh``` script.
```
root@demon-dev:~# ./chroot-start.sh
root@demon-dev:/# /demon-dev/in-chroot-mounts.sh # mounts all necessary OS mount points
root@demon-dev:/# dhclient -v  # in case network did not already happen
```
Next, we **must** set a locale.
```
root@demon-dev:/# export LANGUAGE=en_US.UTF-8
root@demon-dev:/# export LANG=en_US.UTF-8
root@demon-dev:/# export LC_ALL=en_US.UTF-8
root@demon-dev:/# locale-gen en_US.UTF-8
root@demon-dev:/# dpkg-reconfigure locales
root@demon-dev:/# apt update # if this fails, you need to run the previous script, "in-chroot-mounts.sh"
root@demon-dev:/# dbus-uuidgen > /var/lib/dbus/machine-id
```
Next, we **must** install a kernel and a couple other utilities:
```
root@demon-dev:/# apt install linux-image-amd64 live-boot systemd-sysv
```
We can now set our **root** password,
```
root@demon-dev:~# passwd root
```
Finally, now that we are in the "chrooted" environment, we can make all of our updates.

### X11 in Chroot
To start X, the machine requires a window manager, dbus connector, and X initialization applications. In the example below, I install XFCE4 - You can choose what ever you wish, just **ensure that you install ```dbus-x11```**. After that, the ```chroot-start.sh``` and ```in-chroot-mounts.sh``` scripts will handle the rest of the process.
```
root@demon-dev:/# apt install --no-install-recommends xcfe4 dbus-x11 xorg xinit
```
### Generating the ISO Image
This process uses the XORISO utility. Simply run the "./create-iso.sh" program and the image will be created with a timestamp in the file name. Also, I added a call to <code>md5sum</code> for generating an md5 integrity checksum file for your users to check if their download was actually successful. I would recommend using a VMWare Shared directory to copy the ISO file from the working VM to the Host OS for testing.

In the screenshot above, you can see I added some colorful output to the script with ANSI colors and Unicode characters. This is simply to help determine what output is from my script and what is from the external operations of the script. This process can be broken down into a few steps:

* Create "./binary" a working place for our files.
* Copy the kernel to the ./binary directory (initrd and vmlinuz from ./chroot).
* Create the SquashFS filesystem file from ./chroot
* Copy all ISOLINUX files from the hosts installation of the Debian isolinux package into the ./binary/isolinux directory.
* Use the XorrISO utility to generate the ISO file.
* Use MD5Sum to generate the md5 file.

## ISO Installer
The installation process can be broken down into a few key steps. These are VERY important to understanding this process. I wrote my installer based off of Tony's Remastersys Installer which uses <code>rsync</code>, which uses the YAD dialog application for user I/O.

* Use GParted to create a root partition "/" and LINUX-swap partition "swap"
* Get timezone and hostname of new system from user
* Copy everything in the root of the live filesystem into out new root partition usinf rsync, excluding the following directories: wt7, lib/live, live, cdrom, mnt, proc, run, sys, media
* Create some empty directories for the Debian OS: proc, mnt, run, sys, media/cdrom
* Remove some live-OS hooks and return "update-initramfs" back to it's original
* Download and install GRUB and the Linux Kernel
* Set up the new hostname
* Clean up the filesystem logs, and package caches andf reboot

## References
SquashFS-Tools (Debian Package): https://packages.debian.org/search?keywords=squashfs-tools<br />
Remastersys Project: https://en.wikipedia.org/wiki/Remastersys<br />
Rsync: https://en.wikipedia.org/wiki/Rsync<br />
XorrISO: https://www.gnu.org/software/xorriso/<br />
Full UNICODE chart for scripting: http://www.fileformat.info/info/charset/UTF-8/list.htm?start=8192<br />
SYSLINUX: http://www.syslinux.org/wiki/index.php?title=Menu
