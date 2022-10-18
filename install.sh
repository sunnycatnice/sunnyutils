#!/bin/bash

GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
RESET_COLOR='\033[0m'
DEFAULT_COLOR='\033[0m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
ARGV=$@

FILE_ZSHRC="$HOME/.zshrc"
FILE_ZSHRC_TOCOPY="./srcs/tocopy.zshrc"
FILE_VIMRC="$HOME/.vimrc"
FILE_VIMRC_TXT="./srcs/vimrc.bck"
P10K_CONFIG_FILE_PATH="$HOME/.p10k.zsh"
VS_TERMINAL_CONFIG_PATH="$HOME/Library/Application Support/Code/User/settings.json"
SILENT_MODE=false

#print_manager manage the printing process of every message displayed
#usage example: print_message "this is a message" green imporant
#$1: message to print
#$2: color to use (optional)
#$3: importance level (optional)
#important notes:	the message will be printed in the default color if no color is specified
#					only if no argument is specified, the silent mode is taken into account
#if $2 exists, it means that it should print the message with the color $2
#if there's no color, print the message with the default color checking the silent mode
#if $3 exists, it means important mode is activated, so the message will be printed ignoring the silent mode
function print_manager()
{
	#tofix the important mode - not working
	#if $3 exists, it means important mode is activated, so the message will be printed ignoring the silent mode
	if [ -n "$3" ]; then
		if [ "$3" == "important" ] || [ "$3" == "i" ]; then
			#convert $2 to uppercase in zsh
			COLOR=$(echo "$2" | tr '[:lower:]' '[:upper:]')
			echo -e "${!COLOR}$1${RESET_COLOR}"
		fi
	else
	if [ -n "$2" ]; then
		#convert $2 to uppercase
		COLOR=$(echo "$2" | tr '[:lower:]' '[:upper:]')
		echo -e "${!COLOR}$1${RESET_COLOR}"
	else
	if [ $SILENT_MODE = false ]; then
		echo -e "$1"
	fi
	fi
	fi
}

function ascii_art()
{
	printf "\n"
	printf " ${RED} (             ${RESET_COLOR} /\_/\                               ${RED}(\n"
	printf " ${RED} )\ )         ${RESET_COLOR} ( o.o ) ${GREEN} MEOW            ${RED} )     (  )\ ) \n"
	printf " ${RED}(()/(   (     ${RESET_COLOR}  > ^ <  ${BOLD_GREEN} V0.1     ${RED} (   ( /( (   )\(()/( \n"
	printf " ${RED} /(_)) ))\   (                ) ))\  )\()))\ ((_)/(_))\n"
	printf " ${RED}(${RESET_COLOR} __ ${RED}))  /((_)  )\ )   )\ ) (()/(  /((_)(_))/((_) _(_))  \n"
	printf " ${RESET_COLOR}/ __|${RED}(_))(  _(_/(  _(_/(  )(_))(_))( ${RESET_COLOR}| |_  (_)| |/ __| \n"
	printf " ${RESET_COLOR}\__ \| || || ' \))| ' \))| || || || ||  _| | || |\__ \ \n"
	printf " ${RESET_COLOR}|___/ \_,_||_||_| |_||_|  \_,_| \_ _| \__| |_||_||___/ \n"
	printf "                           |__/                         \n"

}

function check_argv()
{
	if [ $# -eq 0 ] ; then
		print_manager "No arguments supplied" yellow
		print_manager "Using default mode" yellow
	fi
	if [ $# -eq 1 ] ; then
		for i  in "$@"
		do
			#if the argument is -s, set SILENT_MODE to true
			if [ $i = "-s" ]  || [ $i = "--silent" ]; then
				SILENT_MODE=true
				print_manager "Silent mode enabled" green i
			fi
		done
	else
		SILENT_MODE=false
	fi
}

#function to check if vim config is already installed, if not, install it
function check_vimrc()
{
	if [ -f $FILE_VIMRC ]; then
		print_manager "File $FILE_VIMRC found!"
	else
		print_manager "File $FILE_VIMRC not found! Creating it..."
		touch $FILE_VIMRC
		print_manager "File $FILE_VIMRC created!"
	fi
}

#function to change git config to use the default git config
function git_config()
{
	MYNAME=$(whoami)
	git config --global user.name "${MYNAME}-MacOS"
	# git config --global user.email "myemail@gmail.com"
	print_manager "✓ Git configured/overwritten!" green
}

#copy the tocpy.zshrc file to the .zshrc file
function copy_zsh()
{
	#remove any previous .zshrc file
	rm -rf $FILE_ZSHRC
	cp $FILE_ZSHRC_TOCOPY ~/.zshrc
	print_manager "✓ .zshrc copied!" green
}

#funzione che legge linea per linea il file FILE_VIMRC_TXT e lo copia in FILE_VIMRC, se la linea è già presente, non fa niente
function copy_vimrc()
{
	while read line; do
		if grep -q "$line" $FILE_VIMRC; then
			print_manager "$line found! doing nothing..."
		else
			echo $line >> $FILE_VIMRC
		fi
	done < $FILE_VIMRC_TXT
}

function download_ohmyzsh()
{
	if [ -d "$HOME/.oh-my-zsh" ]; then
		print_manager "Oh-my-zsh already installed!"
	else
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		print_manager "Oh-my-zsh successfully installed!" green
	fi
}

#funzione che controlla se ~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions è presente, se non lo è, lo crea
#lo crea usando git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
function check_zsh_autosuggestions()
{
	if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
		print_manager "✓ zsh-autosuggestions found! doing nothing..."
	else
		print_manager "zsh-autosuggestions not found! Creating it..."
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		print_manager "✓ zsh-autosuggestions created!" green
	fi
}

#function to check if zsh theme powerlevel10k is present, if not, it creates it
#it creates it using git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
function check_zsh_powerlevel10k()
{
	if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
		print_manager "✓ Powerlevel10k found! doing nothing..."
	else
		rm -rf ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
		print_manager "powerlevel10k not found! Creating it..."
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
		print_manager "✓ Powerlevel10k created!" green
	fi
}

function set_fonts()
{
	STATUS=0
	#check in ~/Library/Fonts if MesloLGSNFBold.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFBold.ttf" ]; then
		print_manager "MesloLGSNFBold.ttf found!"
	else
		print_manager "MesloLGSNFBold.ttf not found! Copying it..." yellow
		cp ./fonts/MesloLGSNFBold.ttf $HOME/Library/Fonts/MesloLGSNFBold.ttf
		STATUS = 1
	fi
	#check in ~/Library/Fonts if MesloLGSNFBoldItalic.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFBoldItalic.ttf" ]; then
		print_manager "MesloLGSNFBoldItalic.ttf found!"
	else
		print_manager "MesloLGSNFBoldItalic.ttf not found! Copying it..." yellow
		cp ./fonts/MesloLGSNFBoldItalic.ttf $HOME/Library/Fonts/MesloLGSNFBoldItalic.ttf
		STATUS = 1
	fi
	#check in ~/Library/Fonts if MesloLGSNFItalic.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFItalic.ttf" ]; then
		print_manager "MesloLGSNFItalic.ttf found!"
	else
		print_manager "MesloLGSNFItalic.ttf not found! Copying it..." yellow
		cp ./fonts/MesloLGSNFItalic.ttf $HOME/Library/Fonts/MesloLGSNFItalic.ttf
		STATUS = 1
	fi
	#check in ~/Library/Fonts if MesloLGSNFRegular.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFRegular.ttf" ]; then
		print_manager "MesloLGSNFRegular.ttf found!"
	else
		print_manager "MesloLGSNFRegular.ttf not found! Copying it..." yellow
		cp ./fonts/MesloLGSNFRegular.ttf $HOME/Library/Fonts/MesloLGSNFRegular.ttf
		STATUS = 1
	fi
	#check if STATUS is 1, if it is, it means that at least one font was copied, so it prints the message
	if [ $STATUS -eq 1 ]; then
		print_manager "! REMEMBER ! You need to restart your machine to see fonts changes" yellow
	fi
}

function set_p10k_config()
{

	rm -rf $HOME/.p10k.zsh
	cp ./srcs/tocopy_p10k.zsh $P10K_CONFIG_FILE_PATH
	print_manager "cp ./srcs/p10k_bck.zsh  $P10K_CONFIG_FILE_PATH"
	print_manager "✓ P10k configured / overwritten!" green
}

#function to change the default font of vs code to MesloLGS NF
function check_vscode_font()
{
	cp ./srcs/vs_terminal_settings.json "$VS_TERMINAL_CONFIG_PATH"
	print_manager "$PWD/vs_terminal_settings.json $VS_TERMINAL_CONFIG_PATH"
}

function finish()
{
	print_manager "zsh configured!"
	#check if bash is the default shell
	if [ "$SHELL" != "/bin/zsh" ]; then
		print_manager "zsh is not the default shell! Changing it..."
		#check if zsh exists
		if [ -f "/bin/zsh" ]; then
			print_manager "zsh found! Changing default shell..."
			chsh -s /bin/zsh
			print_manager "✓ zsh is now the default shell!" green
		else
			print_manager "zsh not found! Please install it and then run this script again!" red
		fi
		print_manager "! Remember to restart your terminal to see any effective changes!" yellow
		exec bash
	else
		print_manager "zsh is already the default shell!"
		exec zsh
	fi
	print_manager "All done! Enjoy your new shell!" bold_green
}

ascii_art

if [ "$(uname)" == "Darwin" ]; then
    print_manager "You're on macOS! Great!" green
	check_argv $@
	set_fonts # macOS only
	check_vimrc
	git_config
	download_ohmyzsh
	copy_zsh
	copy_vimrc # --> to review
	check_zsh_autosuggestions
	check_zsh_powerlevel10k
	check_vscode_font
	set_p10k_config
	finish
else
    print_manager "You are on Linux! Great!" green
	check_argv $@
	check_vimrc
	git_config
	download_ohmyzsh
	copy_zsh
	copy_vimrc
	check_zsh_autosuggestions
	# check_zsh_powerlevel10k --> to make it work for linux
	check_vscode_font
	# set_p10k_config --> to make it work for linx
	finish
fi
