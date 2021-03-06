#!/bin/bash

sudo wifi-menu -o

pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

# Shell
sudo pacman -S bash-completion dfc htop ranger screenfetch unzip zip zsh zsh-completions

# Network cli stuff
sudo pacman -S curl wget dosfstools openssh rsync

### Set up graphical stuff

ONCE="True"
while [[ $ONCE == "True" ]]
do
    echo "Intel, Nvidia, or AMD Graphics?

    (intel)
    (amd)
    (nvidia)
    (none)

"
    read Graphics
    case $Graphics in

	intel)
	    sudo pacman -S xf86-video-intel
	    ONCE="False"
	    ;;

	amd)
	    sudo pacman -S xf86-video-ati
	    ONCE="False"
	    ;;

	nvidia)
	    sudo pacman -S nvidia nvidia-libgl
	    ONCE="False"
	    ;;

	none)
	    ONCE="False"
	    ;;

	*)
	    ;;
    esac
done

# Xorg
sudo pacman -S xbindkeys xcompmgr xf86-input-synaptics xorg-server xorg-server-utils xorg-twm xorg-xclock xorg-xinit xorg-xmodmap xorg-xsetroot

# Emacs
sudo pacman -S emacs

# Networking
sudo pacman -S networkmanager networkmanager-openvpn nmap openvpn wireless_tools wpa_supplicant private-internet-access-vpn pia-tools

# Python Things
sudo pacman -S pygmentize python-pip python-pyflakes python-pygments python-virtualenv python-sympy python-termcolor

# LaTeX
sudo pacman -S texlive-bibtexextra texlive-core texlive-formatsextra texlive-latexextra texlive-pictures texlive-plainextra texlive-science texlive-pstricks

# Spelling
sudo pacman -S aspell aspell-en aspell-fr hunspell

# Add this?
sudo pip install proselint

# Terminal
sudo pacman -S rxvt-unicode urxvt-perls

# Xmonad
sudo pacman -S ghc xmonad xmobar xmonad-contrib cabal-install c2hs
cabal update
cabal install xmonad-contrib

# Stuff
sudo pacman -S feh rofi

# Login Manager
sudo pacman -S lxappearance

# Pandoc
sudo pacman -S pandoc

# Thunar
sudo pacman -S thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tumbler

# Printing
sudo pacman -S cups ghostscript gsfonts system-config-printer cups-filters  cups-pdf
# Pdf
sudo pacman -S zathura zathura-pdf-poppler zathura-ps

# Multiple screens
sudo pacman -S arandr

# ?
sudo pacman -S gvfs

# xmonad, terminal, moc, tmux, emacs, TeX, xinitrc, background, etc
git config --global user.email "bdrum047@uottawa.ca"
git config --global user.name  "Blair Drummond"


# #Audio
sudo pacman -S alsa-utils ffmpeg pulseaudio pulseaudio-alsa pamixer mpd mpc libmpd exfat-utils

# sudo pacman -S ncmpcpp
sudo pacman -S gmpc

sudo mv asound.state /var/lib/alsa/

# don't add user to audio group!
# systemctl enable alsa-state.service
# systemctl start  alsa-state.service


# Raspberry Pi
#	# To get audio out of the headphone jack
#	sudo modprobe snd_bcm2835
#	sudo amixer cset numid=3 1


# Set up AUR (yaourt)
sudo pacman -S --needed base-devel
mkdir aur && cd aur



# Get Package Query
curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
tar -xvf package-query.tar.gz
cd package-query
makepkg -sri



# Get Yaourt
cd /home/blair/aur/
curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
tar -xvf yaourt.tar.gz
cd yaourt
makepkg -sri
cd ~/


# To use sshfs, edit /etc/ssh/sshd_config and start & enable the ssh socket
read -p "Need backlight configuration?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Backlight control
    yaourt -S light-git
fi


# Email setup
sudo pacman -S mutt lynx abook
yaourt -S urlscan-git
yaourt -S t-prot


#Dictionary
yaourt -S wordnet


# Oh-My-Zsh
mv .zshrc temp.zshrc
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
mv temp.zshrc .zshrc


# Network Manager
systemctl enable NetworkManager.service
systemctl start  NetworkManager.service


# Browser
sudo pacman -S firefox flashplugin transmission-gtk
yaourt -S vimb


# To use sshfs, edit /etc/ssh/sshd_config and start & enable the ssh socket
read -p "ssh into this machine?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo echo "AllowUsers blair" >> /etc/ssh/sshd_config
    systemctl enable sshd.socket
    systemctl enable sshd@
    systemctl start sshd.socket
    systemctl start sshd@
fi


# Themes
yaourt -S gtk-theme-arc
yaourt -S ultra-flat-icons

# Transparent windows + shadows
sudo pacman -S compton

# Make ranger highlight stuff
ranger --copy-config=all

# Printer
sudo pacman -S hplip iputils usbutils

# Fonts
sudo pacman -S adobe-source-code-pro-fonts ttf-dejavu ttf-liberation ttf-freefont
yaourt -S ttf-font-awesome

# Browser
yaourt -S jumanji-git

# Time
timedatectl set-timezone America/Toronto
sudo pacman -S ntp
systemctl enable ntpd.service

# IRC
sudo pacman -S weechat

# Xcalib
yaourt -S xcalib

# R
sudo pacman -S r

# ?
sudo pacman -S xdotool

# linux lts
sudo pacman -S linux-lts
grub-mkconfig -o /boot/grub/grub.cfg

# Trayer
# sudo pacman -S trayer network-manager-applet

# battery
sudo pacman -S acpi

echo "Now figure out how to set up Pulse Audio. Good Luck."
echo "(try systemd, setting the sink, and /etc/asoundrc)"




# install dotfiles
sudo pacman -S stow
git clone https://github.com/blairdrummond/dots.git
cd dotfiles
for d in `ls -d */`;
do
    stow $d
done
cd ~/


# Copy scripts into bin for xmobar to use
sudo cp .executable/* /usr/local/bin/

# Desktop notifications
sudo pacman -S xfce4-notifyd
