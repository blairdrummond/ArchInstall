#Grab Arch ISO and prepare the installation media

#Connect to the Internet

> wifi-menu -o

> ping -c 3 www.google.com

#Prepare the hard drives

This step may seem complicated, since it involves formatting your hard drive, but I have tried my best to make it as simple as possible. I looked at it from a new user’s point of view to simplify things without dumbing them down.

We have to now partition our hard drive. We are using the ‘Parted’ tool. Run the lsblk command to see the connected storage devices (check the above note about block devices). And then give the block device name for that drive.

> parted /dev/sdx

> (parted) mklabel msdos

**It will warn you about destroying all data. Type Yes. Now we have to create partitions (keep a note, this tutorial is for MBR/BIOS systems, if you are using a UEFI based system then refer to my other tutorial).**

Use the following pattern to create partitions:

(parted) mkpart part-type fs-type start end

We first need to create the root, so the part-type will be primary; the file system will be ext4. I give more than 20GB to the root partition because I install multiple desktop environments and it’s better to have more space. In addition to that I don’t create separate home partition, it’s created inside the root partition so give root as much storage as you would give to the home partition.

We will also set boot flag on it:

(parted) mkpart primary ext4 1MiB 30GiB
(parted) set 1 boot on

Once root is created we have to create swap and other partitions, if you need. While creating these partitions, keep in mind the start and end is important: the start point will be where you ended the previous one (as you can see below, the start point for root is 30GiB, that’s the end point for the previous partition).

Let’s now create the swap partition:

(parted) mkpart primary linux-swap 30GiB 38GiB

As you can see I provided 8GB for swap partition; you can allot as much space as you need for swap partition.

If you want to create more partitions, then just follow the pattern. If you want to use all of the remaining storage then use 100% for end point.

If you are done partitioning, quit parted and check the partition structure using the lsblk command.



Now we need to format the file system. The root partition must be formatted as ext4

> mkfs.ext4 /dev/sdxY

And we are not going to touch swap. However we have to set it up and activate it:

> mkswap /dev/sdxY
> swapon /dev/sdxY



#Installation

We will now install Arch on our system. First we have to mount the root partition to the ‘mnt’ directory:

> mount /dev/sdxN /mnt

In my case it was sda1:

> mount /dev/sda1 /mnt

#pacman settings and mirrors
We have to now configure the mirror-list so choose the closest mirror for best download speed.

> vim /etc/pacman.d/mirrorlist

Now we install the base packages:

> pacstrap -i /mnt base base-devel

#genfstab?
Once all packages are installed, we have to generate the fstab file. We are using UUIDs, which are more reliable than labels.

> genfstab -U  /mnt > /mnt/etc/fstab

Run the above command only once, even if there are any errors. If there are any error, you must edit the fstab file later, instead of running the command again.

#chroot
Now lets chroot into the new system:

> arch-chroot /mnt /bin/bash

#Locale
We now edit locale.gen file which holds info such as system language, etc:

> vim /etc/locale.gen

Find your language and uncomment entries for it (in my case it was US English):

LANG=en_US.UTF-8

Once the language is uncommented and the file saved, run the following commands, one by one:

> locale-gen
> echo LANG=en_US.UTF-8 > /etc/locale.conf
> export LANG=en_US.UTF-8

#Time & Date
Now configure the time. Run the following command and then follow the simple steps:

tzselect

Once done, it will show you that the time zone will be set in this order. Type 1 or 2 for yes or no as shown. Now created symlink to it:

> ln -s /usr/share/zoneinfo/Zone/SubZone > /etc/localtime

#Clock
And now set the hwclock to UTC:

> hwclock --systohc --utc


#Setting boot manager

Now it’s time to configure boot-loader. Install the package grub.

pacman -S grub

Now run the following command:

> grub-install --recheck --target=i386-pc /dev/sdX


Now generate grub.cfg:

> grub-mkconfig -o /boot/grub/grub.cfg

We are all set with the OS install, we have to now install other components and configure the system. First get the network to work. If you used wifi, you will have to disable dhcpcd service that’s enabled by default:

> systemctl stop dhcpcd@enp0s25.service

And if you are using the wired connection, then enable it and set it to start at reboot. To find the name of wired/wireless devices run ‘ip link’ command that will give you the name of the Interfaces.

To configure dhcpcd to start at boot run the following:

> systemctl start dhcpcd@enp0s25.service
> systemctl enable dhcpcd@enp0s25.service

If you are using wireless, then install these packages (if you are planning to use a desktop environment (DE), then it will be much easier to just use the network management tool for the installed DE):

> pacman -S iw wpa_supplicant dialog


#Hostname

Let’s give our system a decent host name:

> echo blairsMachine > /etc/hostname

#Root Password
Now let’s create the password for the root. Run the following command:

> passwd

#Save and exit
Then exit the chroot environment

> exit

Then unmount the partition

> umount -R /mnt

Then reboot the system:

> reboot




#Add User

> useradd -m -G wheel -s /bin/bash blair

We now have to create password for this user:

> passwd blair

Let’s now install sudo so that this user can perform administrative tasks without becoming root:

> pacman -S sudo
> visudo

Un-comment this line in this file:

```%wheel ALL=(ALL) ALL```

I also suggest installing the bash-completion package which makes it easier with auto-complete of commands and package names.

> pacman -S bash-completion


#Configure repositories

Now we have to set-up some repositories before we start installing packages.

If you are running a 64bit system then you need to enable the ‘multilib repository. Open the pacman.conf file using nano:

> vim /etc/pacman.conf

Scroll down and un-comment the ‘multilib’ repo:

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

> pacman -Sy

Note: You must always update repos before installing any packages.


#Install X

> sudo pacman -S xorg-server xorg-server-utils

It will ask you to install libgl package, choose the one for your GPU. If you have Intel card, then use mesa-libgl, if you have latest nvidia card then nvidia-libgl.

It’s time to now install GPU driver:

##Intel GPU:
> pacman -S xf86-video-intel

#Nvidia
> pacman -S nvidia nvidia-libgl

#ATI/AMD:
> pacman -S xf86-video-ati lib32-mesa-libgl


#Touch-pad
If you are using a laptop you will also need to install the drivers for input devices like touch-pad:

> pacman -S xf86-input-synaptics


#Desktop Environment
> sudo pacman -S xmonad xmobar

**Other Xmonad stuff?**

then

> git init
> git pull https://github.com/blairdrummond/dotfiles.git
