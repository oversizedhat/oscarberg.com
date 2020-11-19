---
title: "Setting up RPi with docker & docker-compose"
date: 2020-11-19T13:12:03Z
tags: ['docker', 'RPi']
draft: false
---
I recently bought a Raspberry Pi 4 2GB for random home use.

The installation went fairly smooth but still required some googling, so if anything this guide might be useful for myself in the future.

1. The [official RPi installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) requires you to have a SD card reader at hand which I did not so I thought I might use my Android phone instead for the installation of Raspberry OS image.
2. Luckily there was even an Android App for it: https://play.google.com/store/apps/details?id=com.redrobe.raspicardimager. In it I went for the standard Raspberry Pi OS 3,2 GB version and seemed to install nicely on the SD card (make sure to tick the 'Enable ssh...' checkbox) However when booting up the RPi with it did not start. After I tried formatting the SD card and installing the same image again it booted up fine. I have no idea if this flaky behavior is something to be expected but it sure had me worried.
3. Start the Pi and change the default password.
4. Connect the RPi to your local wifi and note the aquired IP. For conveniency add the host details to your ~/.ssh/config file.
```bash
Host rpi
    HostName 192.168.0.XXX
    User pi
    Port 22
```
5. Feed a public key to the Pi to avoid hassle of using passwords
```bash
# this will prompt for password
ssh-copy-id rpi
```
6. But afterwards you are can login without any password
```bash
ssh rpi
Linux raspberrypi 5.4.51-v7l+ #1333 SMP Mon Aug 10 16:51:40 BST 2020 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.
...
..
.
GREAT SUCCESS!!
```
----
#### Install docker + docker-compose
There are plenty of guides for this so here is the slimmest one (I believe also assuming you at least installed the 3.2 GB RPi OS):
```bash
sudo apt-get update && sudo apt-get upgrade
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh 
rm -rf get-docker.sh 
sudo usermod -aG docker pi
sudo pip3 install docker-compose
```
Now you are set to do whatever kind of madness you set to to do.

----
#### Bonus, copy a local directory to your Pi
```bash
scp -r folder rpi:/home/pi
```