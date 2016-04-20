#!/bin/bash
# installation of all base-packages
# I started this list for live-build and WT7
## Below are some scripts that NEED to run to make this OS work:
locale-gen
dpkg-reconfigure locales
## Update package lists
apt-get update
## Now get the packages
apt-get install fluxbox \
locales \
locate \
swig \
python-slowaes \
pkg-config \
conky \
xinit \
x11-common \
python-qt4 \
python-dev \
libnl-30-dev \
git \
ruby \
ruby-dev \
gems \
postgresql \
libsqlite3-dev \
libpq-dev \
python \
pip \
vim \
netcat \
iw \
wicd \
gcc \
build-essential \
make \
gdb \
alsa-utils \
linux-image-686-pae \
linux-headers-686-pae \
nasm \
hexer \
hexedit \
flasm \
wget \
curl \
perl \
pcmanfm \
gnome-icon-theme-extras \
gnome-icon-theme gnome-terminal \
iptables \
chkrootkit \
unzip \
telnet \
bleachbit \
macchanger \
libpcap-dev \
nmap \
wireshark \
zenmap \
tcpdump \
locales \
xterm \
dbus \
dialog \
hostapd \
libonig2 \
libqdbm14 \
lsof \
php5-cli \
php5-common \
php5-json \
php5-readline \
python-scapy \
wireshark \
tshark \
wireshark-common \
wireshark-gtk \
pcapfix \
packeth \
ostinato \
netdude \
scite \
alsamixergui \
