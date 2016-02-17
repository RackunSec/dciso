# Debian Custom Iso Scripts and Tutorial
These are scripts I made to help with the design and customization of a Debian ISO (Primarily WeakerThan Linux). This is a work in progress and will be updated with video tutorials, scripts, and lot's of documentation on the process in which I created WT7 Elite.

## Custom Scripts
This repository should help anyone who is unfamiliar with the process of creating a customized ISO. I am making this because I honestly could not find solid, working, up-to-date tutorials anywhere I looked. I could not get Debian's "live-build" working preoperly for the life of me and it just seemed very convoluted. This tutorial and these scripts were designed to work with Debian Stretch. We will be designing our own custom 32bit Debian ISO with the SYSLINUX boot loader.

## Tutorial
Begin by using <code>deboostrap</code> in an empty directory which will build an entire "bare bones" version of Debian applications. This will be our environment for designing our custom ISO.
