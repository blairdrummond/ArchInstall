#!/bin/bash

pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

# Install (no window manager yet)
sudo pacman -S adobe-source-code-pro-fonts arandr aspell aspell-en aspell-fr curl dfc dmenu emacs feh gvfs htop hunspell lxappearance networkmanager networkmanager-openvpn numix-themes openssh openvpn pandoc pygmentize python-pip python-pyflakes python-pygments python-virtualenv ranger rsync screenfetch texlive-bibtexextra texlive-core texlive-formatsextra texlive-latexextra texlive-pictures texlive-plainextra texlive-science thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman ttf-dejavu tumbler unzip wget wireless_tools wpa_supplicant xbindkeys xf86-input-synaptics xf86-video-intel xfce4-screenshooter xfce4-terminal xorg-server xorg-xclipboard xorg-xinit xorg-xmodmap xorg-xsetroot zathura zathura-pdf-poppler zathura-ps zip zsh zsh-completions



# Video card
sudo pacman -S xf86-video-nouveau


# To use sshfs, edit /etc/ssh/sshd_config and start & enable the ssh socket
read -p "haskell stuff? ghc xmonad cabal?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo pacman -S ghc xmobar xmonad xmonad-contrib cabal-install
    cabal update
    cabal install yeganesh
fi


# xmonad, terminal, moc, tmux, emacs, TeX, xinitrc, background, etc
git config --global user.email "bdrum047@uottawa.ca"
git config --global user.name  "Blair Drummond"



# For desktop keyboard bindings, switch branches
function choose_system () {
    read -p "Choose system:

    1) desktop
    2) netbook
" n
    case $n in
	1)
	    git clone -b desktop_xmodmap https://github.com/blairdrummond/dotfiles.git
	    mv dotfiles/*  .
	    mv dotfiles/.* .
	    rm dotfiles -rf
	    ;;
	2)
	    git init
	    git pull https://github.com/blairdrummond/dotfiles.git
	    ;;
	*)
	    echo "Bad option"
	    echo
	    choose_system
	    ;;
    esac
}
choose_system

# Copy scripts into bin for xmobar to use
sudo cp .executable/* /usr/bin/


# #Audio
# sudo pacman -S alsa alsa-utils amixer ffmpeg
# sudo gpasswd -a blair audio
# amixer sset Master unmute

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


# Backlight control
yaourt -S light-git


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
yaourt -S numix-icon-theme-git


# Emacs!!!
systemctl --user enable emacs


# Themes for lightDM
sudo cp ~/.bg.png /usr/share/pixmaps/bg.png
sudo mv lightdm-gtk-greeter.conf /etc/lightdm/
