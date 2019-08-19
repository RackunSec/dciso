# Debian Custom ISO Scripts and Tutorial
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian.

## Custom Scripts
This repository should help anyone who is unfamiliar with the process of creating a customized ISO but this is NO MEANS a full tutorial on the subject. This is just how I do it and I have thoroughly tested every step, but in the world of open-source, small changes can destroy a house of cards, so to speak. Please make sure you report errors with logs or terminal output so I can better help troubleshoot any issues that arise during your ISO building. I am making this because I honestly could not find solid, working, up-to-date tutorials anywhere I looked. I could not get Debian's "live-build" working preoperly for the life of me and it just seemed very convoluted. This tutorial and these scripts were designed to work with Debian Stretch. We will be designing our own custom 32bit Debian ISO with the SYSLINUX boot loader. 

I highly recommend looking at the source code of the scripts. They utilize Bash programming, AWK, SED, and Grep and are written with lots of comments. This should help anyone unfamiliar with the process of creating a live ISO, or even installing an ISO to a HDD. First, we will need to initialize the project.

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
root@demon-dev:/# /demon-dev/in-chroot-mounts.sh
```

### SYSLINUX
We will be using one of the SYSLINUX boot loaders, ISOLINUX, to boot the live image. <br /><br />

ISOLINUX is part of the SYSLINUX project and is the boot loader that is used for CDROM/live disks and ISOs. We have already installed the ISOLINUX package from the Debian repositories in one of the <code>apt</code> commands above. This will install a few files onto our host OS that we need to copy into our "./binary" directory and that is done with our "./create-iso.sh" shell script like so:<br />

Please see: https://github.com/weaknetlabs/debian-custom-iso-scripts/blob/master/create-iso.sh lines 29-37. The markdown is not allowing them to be pasted correctly here.

SYSLINUX is configured using the "./isolinux/" directory files. The first file to load is the "./isolinux/isolinux.cfg" file which makes an <code>include</code> call to "./isolinux/menu.cfg" And sets the user interface using the <code>ui</code> setting, to "vesamenu.c32". This is a "com32" file. "com32" files are binaries either coded in C or Assembly, which simply loads the user interface for the ISOLINUX boot loader as per our specs that we have set in the configuration files, "./isolinux/isolinux.cfg" and "./isolinux/menu.cfg" These files include which boot loader options to include (booting live or live failsafe in our case), spacial configuration settings, screen resolution, background image and even color settings for the text. 
<br />
Take a look at the "./isolinux/menu.cfg" file, you will notice how simple the syntax is for setting upp the boot loader interface. There are a few special things to note about cutomizing this screen with the sytnax found in those files:<br />
* The "./isolinux/splash.png" file NEEDS to be the same exact size as that specified by the <code>menu resolution</code> setting
* The color codes are in hexadecimal format as: #AARRGGBB where "AA" is the opacity of the color on the screen.

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
