#!/bin/bash

# Uncomment stuff from a file
function uncomment () {

    if [[ $1 == "--file" && $3 == "--pattern" ]]; then
	grep   "^#$4" $2
	sed -i "/$4/s/^#//g" $2

    elif [[ $1 == "--pattern" && $3 == "--file" ]]; then
	grep   "^#$2" $4
	sed -i "/$2/s/^#//g" $4

    else
	echo "uncomment pattern in file

Usage:

    > uncomment --file <file>      --pattern <string>

		or

    > uncomment --pattern <string> --file <file>

"
	exit
    fi
}

# Set up Locale
uncomment --file /etc/locale.gen --pattern "en_US.UTF-8"
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8


# Set up Time and Date
ln -s /usr/share/zoneinfo/Canada/Eastern > /etc/localtime
hwclock --systohc --utc


# Grub!!
pacman -S grub

ONCE="True"
while [[ $ONCE == "True" || ! $REPLY =~ ^[Yy]$ ]]
do
    ONCE="False"
    lsblk
    echo "Enter the full name of the boot device"
    read DEVICE

    read -p "You entered \"$DEVICE\". Is this right? " -n 1 -r
    echo
    echo
done
grub-install --recheck --target=i386-pc $DEVICE
grub-mkconfig -o /boot/grub/grub.cfg


# Networking
pacman -S iw wpa_supplicant dialog

#Hostname
echo "Machine name?"
read NEW_HOSTNAME
echo $NEW_HOSTNAME > /etc/hostname
