#!/bin/bash

pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

# Install (no window manager yet)
sudo pacman -S adobe-source-code-pro-fonts arandr aspell aspell-en aspell-fr curl dfc dmenu emacs feh hunspell networkmanager networkmanager-openvpn openssh openvpn pandoc pygmentize python-pip python-pyflakes python-pygments python-virtualenv ranger rsync rxvt-unicode screenfetch texlive-bibtexextra texlive-core texlive-formatsextra texlive-latexextra texlive-pictures texlive-plainextra texlive-science ttf-dejavu unzip urxvt-perls wget wireless_tools wpa_supplicant xbindkeys xf86-input-synaptics xf86-video xfce4-screenshooter xorg-server xorg-xclipboard xorg-xinit xorg-xmodmap zathura zathura-pdf-poppler zathura-ps zip zsh zsh-completions


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
git init
git config --global user.email "bdrum047@uottawa.ca"
git config --global user.name  "Blair Drummond"
git pull https://github.com/blairdrummond/dotfiles.git

# Copy scripts into bin for xmobar to use
# sudo cp .executable/* /usr/bin/
for i in .executable/* ; do
    sudo cp $i /usr/bin/
    sudo chmod +x "/usr/bin/$i"
done

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



# Oh-My-Zsh
mv .zshrc temp.zshrc
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
mv temp.zshrc .zshrc
