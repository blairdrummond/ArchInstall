#!/bin/bash

pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

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


pacman -S sudo highlight tmux vim

# Vim
cp plug.vim /usr/share/vim/vim74/autoload/
cp gruvbox.vim /usr/share/vim/vim74/colors/

echo "
\" syntax highlighting
syntax on


\" Spell check
hi clear SpellBad
hi SpellBad cterm=underline


\" Theme
set background=dark
colorscheme gruvbox

autocmd ColorScheme * highlight Normal ctermbg=None
autocmd ColorScheme * highlight NonText ctermbg=None

\" Goyo
call plug#begin('/etc/vim/plugged')
    Plug 'junegunn/goyo.vim'
call plug#end()

autocmd VimEnter * Goyo

\" Quitting whether Goyo is active or not
ca wq :w<cr>:call Quit()<cr>
ca q :call Quit()<cr>
function! Quit()
    if exists('#goyo')
        Goyo
    endif
    quit
endfunction
" >> /etc/vimrc

	echo "Now we're going to run vim. You need to just ignore any errors and type

    > :PlugInstall

That should install Goyo system wide.
"
pause
vim


# Add User
useradd -m -G wheel -s /bin/bash blair

echo "blair's password"
passwd blair
echo

# Change root password
echo
echo "root password"
passwd
echo


#Give permissions to wheel
uncomment --pattern "%wheel ALL=(ALL) ALL" --file /etc/sudoers


# Set up the next step
mkdir /home/blair
# cp initialize.sh lightdm-gtk-greeter.conf asound.state /home/blair
cp initialize.sh asound.state /home/blair
chown --recursive blair /home/blair




echo
echo "Now log into blair and run the script"



# LightDM
# pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xorg-server-xephyr
# systemctl enable lightdm.service
# chown lightdm.lightdm /vat/lib/lightdm/
