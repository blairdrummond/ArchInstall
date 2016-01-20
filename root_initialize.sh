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

echo "
syntax on
colorscheme desert

call plug#begin('/etc/vim/plugged')
    Plug 'junegunn/goyo.vim'
call plug#end()

autocmd VimEnter * Goyo
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


#Give permissions to wheel
uncomment --pattern "%wheel ALL=(ALL) ALL" --file /etc/sudoers


# Set up the next step
mkdir /home/blair
cp initialize.sh /home/blair
chown --recursive blair /home/blair

echo
echo "Now log into blair and run the script"
