# Debian Custom ISO Scripts and Tutorial
These are scripts that I made to help with the design and customization of a Debian ISO (Primarily [DEMON LINUX](https://demonlinux.com/)). These scripts have recently been updated to accomodate newer distributions of Debian.

### Dependencies
In your development OS, we need a few tools installed to build out our new Custom Debian. You can install these easily using the following command,
```
root@demon:~# apt install debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools live-build
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
# if the locales failed previously, try again now that we have a new uid:
root@demon-dev:/# dpkg-reconfigure locales
```
Next, we **must** install a kernel and a couple other utilities:
```
root@demon-dev:/# apt install linux-image-amd64 live-boot systemd-sysv
```
We can now set our **root** password,
```
root@demon-dev:~# passwd root
```
We also must edit the (included) grub/grub.cfg file:
```
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
root@demon-dev:/# apt install --no-install-recommends xfce4 dbus-x11 xorg xinit
```

## References
SquashFS-Tools (Debian Package): https://packages.debian.org/search?keywords=squashfs-tools<br />
Remastersys Project: https://en.wikipedia.org/wiki/Remastersys<br />
Rsync: https://en.wikipedia.org/wiki/Rsync<br />
XorrISO: https://www.gnu.org/software/xorriso/<br />
Full UNICODE chart for scripting: http://www.fileformat.info/info/charset/UTF-8/list.htm?start=8192<br />
SYSLINUX: http://www.syslinux.org/wiki/index.php?title=Menu
Will Haley: https://willhaley.com/blog/custom-debian-live-environment/
