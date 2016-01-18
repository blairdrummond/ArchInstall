#!/bin/bash

pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

# Install (no window manager yet)
sudo pacman -S adobe-source-code-pro-fonts alsa-utils arandr aspell aspell-en aspell-fr curl dfc dmenu emacs feh ffmpeg firefox hunspell moc networkmanager networkmanager-openvpn openssh openvpn pandoc pygmentize python-pyflakes python-pygments python-virtualenv python-pip ranger redshift rsync sshfs screenfetch texlive-bibtexextra texlive-core texlive-formatsextra texlive-latexextra texlive-pictures texlive-plainextra texlive-science ttf-inconsolata unzip wget wireless_tools wpa_supplicant xbindkeys xf86-input-synaptics xfce4-screenshooter xfce4-terminal xorg-server zathura zathura-pdf-poppler zathura-ps zip zsh zsh-completions

# To use sshfs, edit /etc/ssh/sshd_config and start & enable the ssh socket
read -p "haskell stuff? ghc xmonad cabal?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo pacman -S ghc xmobar xmonad cabal-install
    cabal update
    cabal install yeganesh
fi


# xmonad, terminal, moc, tmux, emacs, TeX, xinitrc, background, etc
git init
git pull https://github.com/blairdrummond/dotfiles.git

# Copy scripts into bin for xmobar to use
sudo cp .executable/* /usr/bin/

#Audio
sudo gpasswd -a blair audio
amixer sset Master unmute

# Raspberry Pi
#	# To get audio out of the headphone jack
#	sudo modprobe snd_bcm2835
#	sudo amixer cset numid=3 1


# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh

# Set up AUR (yaourt)
pacman -S --needed base-devel
mkdir aur && cd aur
curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
tar -xvf yaourt.tar.gz
cd yaourt
makepkg -sri

# Backlight control
yaourt -S light-git
