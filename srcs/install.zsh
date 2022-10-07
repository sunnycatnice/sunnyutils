#!/bin/bash
#DO NOT RUN THIS SCRIPT DIRECTLY, RUN config.sh INSTEAD

GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
RESET_COLOR='\033[0m'
DEFAULT_COLOR='\033[0m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
ARGV=$@

FILE_ZSHRC="$HOME/.zshrc"
FILE_ZSHRC_TXT="tocopy.zshrc"
FILE_VIMRC="$HOME/.vimrc"
FILE_VIMRC_TXT="vimrc.txt"
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

function check_brew()
{
	if [ -d "$HOME/goinfre/.test/.brew" ]; then
		export PATH="$HOME/goinfre/.test/.brew/bin:$HOME/goinfre/.test/.brew/sbin:$PATH";
		print_manager 'export PATH="/goinfre/dmangola/.test/.brew/bin:$PATH"' >> ~/.zshrc
		print_manager "Brew path added to zshrc!"
	else
		git clone --depth=1 https://github.com/Homebrew/brew ~/goinfre/.test/.brew;
		export PATH="$HOME/goinfre/.test/.brew/bin:$HOME/goinfre/.test/.brew/sbin:$PATH";
		print_manager "✓ Brew successfully installed and exported!" green
	fi

	# if [ "$1" == "init-cask" ]; then
	# 	print_manager "export HOMEBREW_CASK_OPTS=\"--appdir=~/goinfre/.Applications --caskroom=~/.goinfre/.test/.brew/Caskroom\"" >> ~/.zshrc
	# 	print_manager "cask initialized!"
	# fi
}

#function to change git config to use the default git config
function git_config()
{
	git config --global user.name "dani-MacOS"
	git config --global user.email "sio2guanoeleo@gmail.com"
	print_manager "✓ Git configured/overwritten!" green
}

#copy the tocpy.zshrc file to the .zshrc file
function copy_zsh()
{
	#remove any previous .zshrc file
	rm -rf $FILE_ZSHRC
	cp $FILE_ZSHRC_TXT ~/.zshrc
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
#it creates it using git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
function check_zsh_powerlevel10k()
{
	# if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
	# 	print_manager "✓ Powerlevel10k found! doing nothing..."
	# else
	rm -rf ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
	print_manager "powerlevel10k not found! Creating it..."
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	print_manager "✓ Powerlevel10k created!" green
	# fi
}

function set_fonts()
{
	#check in ~/Library/Fonts if MesloLGSNFBold.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFBold.ttf" ]; then
		print_manager "MesloLGSNFBold.ttf found!"
	else
		print_manager "MesloLGSNFBold.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFBold.ttf $HOME/Library/Fonts/MesloLGSNFBold.ttf
	fi
	#check in ~/Library/Fonts if MesloLGSNFBoldItalic.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFBoldItalic.ttf" ]; then
		print_manager "MesloLGSNFBoldItalic.ttf found!"
	else
		print_manager "MesloLGSNFBoldItalic.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFBoldItalic.ttf $HOME/Library/Fonts/MesloLGSNFBoldItalic.ttf
	fi
	#check in ~/Library/Fonts if MesloLGSNFItalic.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFItalic.ttf" ]; then
		print_manager "MesloLGSNFItalic.ttf found!"
	else
		print_manager "MesloLGSNFItalic.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFItalic.ttf $HOME/Library/Fonts/MesloLGSNFItalic.ttf
	fi
	#check in ~/Library/Fonts if MesloLGSNFRegular.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFRegular.ttf" ]; then
		print_manager "MesloLGSNFRegular.ttf found!"
	else
		print_manager "MesloLGSNFRegular.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFRegular.ttf $HOME/Library/Fonts/MesloLGSNFRegular.ttf
	fi
}

#function to check if in the file $HOME/.zshrc there is the line containing the string "ZSH_THEME="robbyrussell""
#then delete that line and create a new one containing "ZSH_THEME="powerlevel10k/powerlevel10k""
function check_zsh_theme()
{
	if grep -q "ZSH_THEME=\"robbyrussell\"" $FILE_ZSHRC; then
		#change from robbyrussell to powerlevel10k
		sed -i '' "s/robbyrussell/powerlevel10k\/powerlevel10k/" $FILE_ZSHRC
		print_manager "✓ ZSH_THEME changed!" green
	fi
}

function set_p10k_config()
{

	rm -rf $HOME/.p10k.zsh
	cp $PWD/tocopy_p10k.zsh $P10K_CONFIG_FILE_PATH
	print_manager "cp $PWD/p10k_bck.zsh  $P10K_CONFIG_FILE_PATH"
	print_manager "✓ P10k configured / overwritten!" green
}

#function to disable the p10k configuration wizard by adding POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true to $HOME/.zshrc if not present
function check_p10k_configuration_wizard()
{
	if grep -q "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" $FILE_ZSHRC; then
		print_manager "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true found! doing nothing..."
	else
		print_manager "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true not found! Creating it..."
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" >> $FILE_ZSHRC
		print_manager "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true created!"
	fi
}

#function to change the default font of vs code to MesloLGS NF
function check_vscode_font()
{
	#!/bin/bash
	cp $PWD/vs_terminal_settings.json "$VS_TERMINAL_CONFIG_PATH"
	print_manager "$PWD/vs_terminal_settings.json $VS_TERMINAL_CONFIG_PATH"
	#!/bin/zsh
}

#in

function finish()
{
	print_manager ciao
	print_manager "zsh configured!"
	# clear
	print_manager "All done! Enjoy your new shell!" bold_green
	# exec zsh
}

ascii_art
check_argv $@
set_fonts
check_brew
check_vimrc
git_config
download_ohmyzsh
copy_zsh
copy_vimrc
check_zsh_autosuggestions
check_zsh_powerlevel10k
check_zsh_theme
check_vscode_font
set_p10k_config
check_p10k_configuration_wizard
finish
