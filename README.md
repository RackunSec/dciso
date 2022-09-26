# Debian Custom ISO Scripts and Tutorial
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian.

### Setup
Begin by creating a fresh VM of the latest version of Debian. Do not install any desktop GUI environments if you plan on developing a desktop environment in your ISO. If Debian installs GDM by default you can remove it using the following command:
```bash
apt remove gdm3
```
Just ensure that when you boot your build/host OS, you are dropped to a login prompt in the terminal, not a GUI login.

### Dependencies
In your development OS, we need a few tools installed to build out our new Custom Debian. You can install these easily using the following command,
```bash
apt install debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools live-build git vim curl dosfstools
git clone https://github.com/RackunSec/debian-custom-iso-scripts
cd debian-custom-iso-scripts
```

### Initialize the Project
The first part, is simply customizing the Debian ISO, in our case the Weakerthan LINUX flavor. The process is that same for starting from scratch, but you need to run the command:
```bash
initialize-build-process.sh buster
``` 
This will install all of the necessary tools to build the ISO and download the Debian LINUX system including packages and system configurations using the `lb` live-build Debian tool. Once this builds the ISO, we can then use the following steps in the "Updating an ISO" section to make our customizations before creating our own ISO.

### Build in Customizations
we now have the directory ```./chroot``` which contains our soon-to-be live ISO OS. We need to biuld a place within the ```./chroot``` directory which will hold our "in chroot scripts" like so,
```bash
mkdir chroot/demon-dev
cp in-chroot-scripts/* chroot/demon-dev
```
Now, we can change root (chroot) into our new ```./chroot``` directory and run the ```/demon-dev/in-chroot-mounts.sh``` script to prepare our environment for customizations. To begin, we simply need to run the following command to change root into the ```./chroot``` directory and once done, run the ```/demon-dev/in-chroot-mounts.sh``` script.
```bash
./chroot-start.sh
/demon-dev/in-chroot-mounts.sh # mounts all necessary OS mount points
dhclient -v  # in case network did not already happen
apt update
```
Next, we **must** set a locale.
```bash
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
apt update # if this fails, you need to run the previous script, "in-chroot-mounts.sh"
dbus-uuidgen > /var/lib/dbus/machine-id
# if the locales failed previously, try again now that we have a new uid:
dpkg-reconfigure locales
```
Next, we **must** install a kernel and a couple other utilities:
```bash
apt install linux-image-amd64 live-boot systemd-sysv
update-initramfs -u
```
We can now set our **root** password,
```bash
passwd root
```
[OPTIONAL] We may need to install some things in the chroot that we will use to build our ISO environment.
```bash
apt install vim ftp open-vm-tools curl git python3-pip
```

We also must edit the (included) grub/grub.cfg file:
```grub
search --set=root --file /DEMON_CUSTOM

insmod all_video

set default="0"
set timeout=30

menuentry "Demon Linux (x64)" {
    linux /vmlinuz boot=live quiet nomodeset
    initrd /initrd
}
```
Finally, now that we are in the "chrooted" environment, we can make all of our updates.

### X11 in Chroot
To start X, the machine requires a window manager, dbus connector, and X initialization applications. In the example below, I install XFCE4 - You can choose what ever you wish, just **ensure that you install ```dbus-x11```**. After that, the ```chroot-start.sh``` and ```in-chroot-mounts.sh``` scripts will handle the rest of the process.
```
apt install --no-install-recommends xfce4 dbus-x11 xorg xinit
```
### Booting Live as Root User + XFCE4
To have your live ISO boot directly into the desktop environment as the root user, simply add the following contents to `/etc/rc.local` (you may have to create this file). 
```bash
#!/bin/bash
su -c "bash -c \"cd /root && startx\""
exit 0
```
Then make the file executable with the following command:
```bash
chmod +x /etc/rc.local
```
This will log in as root, but the desktop wallpaper will be changed to the default. To fix this ... 

# Notes on Live-Build vs. Bullseye (WIP)
This is a collection of notes that I made while trying to decipher what happened to `live-build` since Buster. It no longer acts the same way and seems no longer applicable to my project. First of all, I made this an executable script as `/usr/bin/lb-config.sh`: 

```bash
#!/bin/bash
lb config \
    --mode debian \
    --system live \
    --interactive x11 \
    --distribution bullseye \
    --debian-installer live \
    --architecture amd64 \
    --archive-areas "main contrib non-free" \
    --security true \
    --updates true \
    --binary-images iso-hybrid \
    --memtest memtest86+
```

This script builds the initial chroot, but will fail when starting `x11` due to poor `live-build` developer decisions. The reason why is that to run `x11` within a chroot, you must mount a lot of stuff in the chroot first.

**note**: Any time we make chnages or run `lb clean` etc, we must run `lb config` again before running `lb build`.
**note**: I call my build directory `demon-dev` for Demon Linux building. This is where I run the `lb-config.sh`, `lb config`, `lb build` commands.

### X11 Issues
1. rc.local is ignored at boot and x11 starts with `live-user`
2. tried making a service and enabling it: failed
3. sometimes `chroot/etc/rc.local` disappears after building
4. got everything working (sometimes, as if Debian were rolling dice at boot), but the desktop background would not display (just the default image did)
5. Updated the desktop-background.xml file which shows the correct wallpaper in the live ISO, but no lset onger as root? wtf?

### Adding Packages
1. Adding packages works fine, but since we cannot get X11 to start with the `root` user, the customizations made to the desktop do not show upon booting into the ISO.

### Lb Build Errors
1. had to disable my VPN conenction or connection issues occurred ?
2. `--interactive x11` never worked, not even once, I get: `Cannot open /dev/tty0 (No such file or directory)`
    - Remove `xserver-xorg-legacy` [Reference](https://github.com/dnschneid/crouton/issues/3339) `chroot chroot` and `apt update` and `apt remove xserver-xorg-legacy`
    - First, in the host OS, install `dbus-x11 xfce4` with `apt` 
    - disable X11 from autostarting at boot: `systemctl set-defaul multi-user.target`
    - clone this repository into your home directory
    - make the chroot dev dir: `mkdir chroot/app-dev`
    - copy the files from this repo: `cp debian-custom-iso-scripts/in-chroot-scripts/* chroot/app-dev`
    - copy the chroot init and end files into the build directory: `cp debian-custom-iso-scripts/chroot-* demon-dev`
    - cd into the build directory `cd demon-dev` and run `./chroot-start.sh`
    - Now, within the chroot, run `/app-dev/in-chroot-mounts.sh` to mount the necessary devices for x11.
    - `cd /root && startx` should start xfce4 and you should be able to start your customizations.
    - to exit, simply log out of xfce4, then run `/app-dev/in-chroot-umounts.sh` (notice the `u`) and exit the chroot `CTRL+d`
    - Then, run `./chroot-end.sh` and reboot.
  
# References
SquashFS-Tools (Debian Package): https://packages.debian.org/search?keywords=squashfs-tools

Remastersys Project: https://en.wikipedia.org/wiki/Remastersys

Rsync: https://en.wikipedia.org/wiki/Rsync

XorrISO: https://www.gnu.org/software/xorriso/

Full UNICODE chart for scripting: http://www.fileformat.info/info/charset/UTF-8/list.htm?start=8192

SYSLINUX: http://www.syslinux.org/wiki/index.php?title=Menu

Will Haley (This works with <= Debian Buster): https://willhaley.com/blog/custom-debian-live-environment/

TerkeyBerger (Bullseye): https://terkeyberger.wordpress.com/2022/03/07/live-build-how-to-build-an-installable-debian-10-buster-live-cd/

Debian Docs (Latest): https://live-team.pages.debian.net/live-manual/html/live-manual/customizing-package-installation.en.html 
