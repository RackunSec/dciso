# Debian Custom ISO Scripts and Tutorial
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily WeakerThan Linux). This is a work in progress and will be updated with video tutorials, scripts, and lots of documentation on the process in which I created WT7 Elite. As of 01.30.2017 these scripts can now do 32 bit Debian or amd64 Debian compiled kernels with the latest (LTS) stable version, "8.7, Jessie."

<img src="https://weaknetlabs.com/images/dev-img.png"/>
<i>Screenshot: Weakerthan LINUX 7 "Elite" Alpha, tested in Oracle's VirtualBox.</i>

## Custom Scripts
This repository should help anyone who is unfamiliar with the process of creating a customized ISO but this is NO MEANS a full tutorial on the subject. This is just how I do it and I have thoroughly tested every step, but in the world of open-source, small changes can destroy a house of cards, so to speak. Please make sure you report errors with logs or terminal output so I can better help troubleshoot any issues that arise during your ISO building. I am making this because I honestly could not find solid, working, up-to-date tutorials anywhere I looked. I could not get Debian's "live-build" working preoperly for the life of me and it just seemed very convoluted. This tutorial and these scripts were designed to work with Debian Stretch. We will be designing our own custom 32bit Debian ISO with the SYSLINUX boot loader. 

I highly recommend looking at the source code of the scripts. They utilize Bash programming, AWK, SED, and Grep and are written with lots of comments. This should help anyone unfamiliar with the process of creating a live ISO, or even installing an ISO to a HDD. It's what I did, anyways. I peered into the source of Tony's Remastersys Project. Tony understood this process very well and his scripts to automate it were what I used for years until his project was ditched. The processes that he started have changed with the new Debian and GNU LINUX kernel updates. So, I built my installer and ISO creation scripts from scratch using Tony's work as a reference point.

## Tutorial
The first part, is simply customizing the Debian ISO, in our case the Weakerthan LINUX flavor. The process is that same for starting from scratch, but you need to run the "initialize-build-process.sh" script which will install all of the necessary tools to build the ISO and download the Debian LINUX system including packages and system configurations using the "lb" live-build Debian tool. I actually don't recommend doing this, but if you really want to start from scratch, do it this way instead of updating an ISO.

### Updating an ISO
This process begins with a pre-existing ISO that you would like to make changes to. To start, we need an installation of Linux with lots of space and some tools installed. I figured out how to do this because, halfway through the development process of WT 7 Alpha, I lost my work. There are a few steps involved with getting a chroot envionment from an ISO and they are:
* Get the ISO
* Extract the filesystem - the root directory with /mnt, /dev, /home, /proc, /sys, /var, /etc, etc in it. This is compressed into a SquashFS in Weakerthan LINUX, but not all LINUXs. Mount the ISO as a loop device and extract the filesystem.squashfs file.
  * <code>mkdir ./mnt</code> 
  * <code>mount -o loop linux.iso ./mnt</code>
  * <code>apt-get install squashfs-tools</code>
  * <code>unsquashfs ./mnt/live/filesystem.squashfs</code>
* This will create a directory, "squashfs-root". Let's copy all of the contents in ./squashfs-root/squashfs-root into ./squashfs-root and rename it "chroot" This just cleans up our development environment and is not required.
  * <code>mv squashfs-root chroot</code>
  * <code>mv chroot/* chroot</code>
  * <code>rm -rf chroot/squashfs-root</code>

Now we have a clone of the live filesystem and we can chroot to it and customize it and make our changes. To "chroot" means to change the root directory. To "chroot" we use the <code>chroot ./chroot</code> command. We will call our host OS, the "host" and the chroot envionment the "chroot" from here on. When we are done making changes in the chroot, we can simply type "exit" or CTRL+D to exit the chroot. Let's continue on and install the tools necessary to build the ISO.

<code>locale-gen en_US.UTF-8</code><br />

Select your locale by hitting the space bar when it is selected in the menu.

<code>dpkg-reconfigure locales</code><br />

Select your locale and hit ENTER, I am using en_US.UTF-8 as shown in the first command.

<code>apt-get update</code><br />
<code>apt-get install deboostrap isolinux live-build</code>

Copy the "in-chroot-scripts" directory in the "./chroot" directory so that we can access them once we have chrooted. Before we "chroot" though, we need to mount /dev/, /dev/pts, /proc, and /sys - bound to the actual host-mounted devices. I do this in the "chroot-script.sh" script. So, after runing the script, you will be chrooted in the new environment.

<code>cp ./debian-custom-iso-scripts ./chroot/tmp/</code>
<code>./chroot-script.sh</code>

In the new chrooted envionment, we need to run the "wt7-mounts.sh" script. This will double check the mounted fileystems we just did and set up the environment, including generating a new uuid for the system. We don't need to run this each time we chroot to "./chroot" once ran, the devices will stay mounted to their respective mountpoints even when we exit the chroot with CTRL+D. 

<code>./wt7-mounts.sh</code>

Now we can install the kernel, packages, and customize the crap out of the new OS workspace! Once done with our customizations, we simply run the "wt7-umount.sh" script. This will clean up the ISO and unmount the filesystems and exit us back to the host environment.

###SYSLINUX
We will be using one of the SYSLINUX boot loaders, ISOLINUX, to boot the live image. <br /><br />
<img src="https://weaknetlabs.com/images/isolinux-screenshot.png" /><br />
<i>Screenshot: The cutomized ISOLINUX splash screen for boot options.</i><br /><br />
ISOLINUX is part of the SYSLINUX project and is the boot loader that is used for CDROM/live disks and ISOs. We have already installed the ISOLINUX package from the Debian repositories in one of the <code>apt</code> commands above. This will install a few files onto our host OS that we need to copy into our "./binary" directory and that is done with our "./create-iso.sh" shell script like so:<br />

Please see: https://github.com/weaknetlabs/debian-custom-iso-scripts/blob/master/create-iso.sh lines 29-37. The markdown is not allowing them to be pasted correctly here.

SYSLINUX is configured using the "./isolinux/" directory files. The first file to load is the "./isolinux/isolinux.cfg" file which makes an <code>include</code> call to "./isolinux/menu.cfg" And sets the user interface using the <code>ui</code> setting, to "vesamenu.c32". This is a "com32" file. "com32" files are binaries either coded in C or Assembly, which simply loads the user interface for the ISOLINUX boot loader as per our specs that we have set in the configuration files, "./isolinux/isolinux.cfg" and "./isolinux/menu.cfg" These files include which boot loader options to include (booting live or live failsafe in our case), spacial configuration settings, screen resolution, background image and even color settings for the text. 
<br />
Take a look at the "./isolinux/menu.cfg" file, you will notice how simple the syntax is for setting upp the boot loader interface. There are a few special things to note about cutomizing this screen with the sytnax found in those files:<br />
* The "./isolinux/splash.png" file NEEDS to be the same exact size as that specified by the <code>menu resolution</code> setting
* The color codes are in hexadecimal format as: #AARRGGBB where "AA" is the opacity of the color on the screen.

### Generating the ISO Image
This process uses the XorrISO utility. Simply run the "./create-iso.sh" program and the image will be created with a timestamp in the file name. Also, I added a call to <code>md5sum</code> for generating an md5 integrity checksum file for your users to check if their download was actually successful. I would recommend using a VMWare Shared directory to copy the ISO file from the working VM to the Host OS for testing.

<img src="https://weaknetlabs.com/images/create-iso.png" /><br />
<i>Screenshot: The ISO generation script as part of this project</i>

In the screenshot above, you can see I added some colorful output to the script with ANSI colors and Unicode characters. This is simply to help determine what output is from my script and what is from the external operations of the script. This process can be broken down into a few steps:

* Create "./binary" a working place for our files.
* Copy the kernel to the ./binary directory (initrd and vmlinuz from ./chroot).
* Create the SquashFS filesystem file from ./chroot
* Copy all ISOLINUX files from the hosts installation of the Debian isolinux package into the ./binary/isolinux directory.
* Use the XorrISO utility to generate the ISO file.
* Use MD5Sum to generate the md5 file.

<img src="https://weaknetlabs.com/images/create-iso-2.png"/><br />
<i>In the screenshot above, is the end of the ISO genertation script.</i>

### Creating a New Image From Scratch
This process is exactly the same as the process above, but we need to get the Debian FS, packages, and LINUX kernel before hand. We do so by running the "initialize-build-process.sh" script. DO NOT RUN THIS IF YOU ALREADY HAVE A "chroot" environment with customized changes in it. It WILL BE DESTROYED. Once done, you can go back uup to the "Updating an ISO" section and begin updating LINUX.

Live-Build must be installed on the host OS before runningthis script, as "lb" will be used. You acn install it with the following command: <code>apt-get install live-build</code> as root or ad <code>sudo</code>.

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

I have code all of this, again using the YAD dialog tool in the "./installer/wt7-installer.run".

Check out the installer video demonstration on a VMWare 10GB Virtual Disk on Vimeo.com: https://vimeo.com/163707783

## References
SquashFS-Tools (Debian Package): https://packages.debian.org/search?keywords=squashfs-tools<br />
Remastersys Project: https://en.wikipedia.org/wiki/Remastersys<br />
Rsync: https://en.wikipedia.org/wiki/Rsync<br />
XorrISO: https://www.gnu.org/software/xorriso/<br />
Full UNICODE chart for scripting: http://www.fileformat.info/info/charset/UTF-8/list.htm?start=8192<br />
SYSLINUX: http://www.syslinux.org/wiki/index.php?title=Menu
