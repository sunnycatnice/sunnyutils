#!/bin/zsh
#DO NOT RUN THIS SCRIPT DIRECTLY, RUN config.sh INSTEAD

GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
RESET_COLOR='\033[0m'
RED='\033[0;31m'

FILE_ZSHRC="$HOME/.zshrc"
FILE_ZSHRC_TXT="zshrc.txt"
FILE_VIMRC="$HOME/.vimrc"
FILE_VIMRC_TXT="vimrc.txt"
P10K_CONFIG_FILE_PATH="$HOME/.p10k.zsh"
VS_TERMINAL_CONFIG_PATH="$HOME/Library/Application Support/Code/User/settings.json"
SILENT_MODE=false

function print_silent 
{
	#if SILENT_MODE is flase, print the message
	if [ $SILENT_MODE = false ]; then
		echo -e "$1"
	fi
}

function print_green()
{
	echo $GREEN$1$RESET_COLOR
}

function print_bold_green()
{
	echo $BOLD_GREEN$1$RESET_COLOR
}

function print_red
{
	echo $RED$1$RESET_COLOR
}

function check_argv()
{
	if [ $# -eq 0 ] ; then
		print_red "No arguments supplied"
		print_red "Using default mode"
	fi
	if [ $# -eq 1 ] ; then
		for i  in "$@"
		do
			#if the argument is -s, set SILENT_MODE to true
			if [ $i = "-s" ] || [ $i = "--silent"]; then
				SILENT_MODE=true
				print_green "Silent mode enabled"
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
		echo "File $FILE_VIMRC found!"
	else
		echo "File $FILE_VIMRC not found! Creating it..."
		touch $FILE_VIMRC
		echo "File $FILE_VIMRC created!"
	fi
}

function check_brew()
{
	if [ -d "$HOME/goinfre/.test/.brew" ]; then
		export PATH="$HOME/goinfre/.test/.brew/bin:$HOME/goinfre/.test/.brew/sbin:$PATH";
		echo 'export PATH="/goinfre/dmangola/.test/.brew/bin:$PATH"' >> ~/.zshrc
		echo "Brew path added to zshrc!"
	else
		git clone --depth=1 https://github.com/Homebrew/brew ~/goinfre/.test/.brew;
		export PATH="$HOME/goinfre/.test/.brew/bin:$HOME/goinfre/.test/.brew/sbin:$PATH";
		print_green "Brew successfully installed and exported!"
	fi

	# if [ "$1" == "init-cask" ]; then
	# 	echo "export HOMEBREW_CASK_OPTS=\"--appdir=~/goinfre/.Applications --caskroom=~/.goinfre/.test/.brew/Caskroom\"" >> ~/.zshrc
	# 	echo "cask initialized!"
	# fi
}

#function to change git config to use the default git config
function git_config()
{
	git config --global user.name "dani-MacOS"
	git config --global user.email "sio2guanoeleo@gmail.com"
	print_green "Git configured/overwritten!"
}

#funzione che legge linea per linea il file FILE_ZSHRC_TXT e lo copia in FILE_ZSHRC, se la linea è presente nel file FILE_ZSHRC, non fa niente
function copy_zsh()
{
	while read line; do
		if grep -q "$line" $FILE_ZSHRC; then
			echo "$line found! doing nothing..."
		else
			echo $line >> $FILE_ZSHRC
		fi
	done < $FILE_ZSHRC_TXT
}

#funzione che legge linea per linea il file FILE_VIMRC_TXT e lo copia in FILE_VIMRC, se la linea è già presente, non fa niente
function copy_vimrc()
{
	while read line; do
		if grep -q "$line" $FILE_VIMRC; then
			echo "$line found! doing nothing..."
		else
			echo $line >> $FILE_VIMRC
		fi
	done < $FILE_VIMRC_TXT
}

function download_ohmyzsh()
{
	if [ -d "$HOME/.oh-my-zsh" ]; then
		echo "Oh-my-zsh already installed!"
	else
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		print_green "Oh-my-zsh successfully installed!"
	fi
}

#funzione che controlla se ~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions è presente, se non lo è, lo crea
#lo crea usando git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
function check_zsh_autosuggestions()
{
	if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
		echo "zsh-autosuggestions found! doing nothing..."
	else
		echo "zsh-autosuggestions not found! Creating it..."
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		print_green "zsh-autosuggestions created!"
	fi
}

#function to check if zsh theme powerlevel10k is present, if not, it creates it
#it creates it using git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
function check_zsh_powerlevel10k()
{
	if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
		echo "powerlevel10k found! doing nothing..."
	else
		echo "powerlevel10k not found! Creating it..."
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
		print_green "powerlevel10k created!"
	fi
}

function set_fonts()
{
	#check in ~/Library/Fonts if MesloLGSNFBold.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFBold.ttf" ]; then
		echo "MesloLGSNFBold.ttf found!"
	else
		echo "MesloLGSNFBold.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFBold.ttf $HOME/Library/Fonts/MesloLGSNFBold.ttf
	fi
	#check in ~/Library/Fonts if MesloLGSNFBoldItalic.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFBoldItalic.ttf" ]; then
		echo "MesloLGSNFBoldItalic.ttf found!"
	else
		echo "MesloLGSNFBoldItalic.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFBoldItalic.ttf $HOME/Library/Fonts/MesloLGSNFBoldItalic.ttf
	fi
	#check in ~/Library/Fonts if MesloLGSNFItalic.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFItalic.ttf" ]; then
		echo "MesloLGSNFItalic.ttf found!"
	else
		echo "MesloLGSNFItalic.ttf not found! Copying it..."
		cp ./fonts/MesloLGSNFItalic.ttf $HOME/Library/Fonts/MesloLGSNFItalic.ttf
	fi
	#check in ~/Library/Fonts if MesloLGSNFRegular.ttf exists
	if [ -f "$HOME/Library/Fonts/MesloLGSNFRegular.ttf" ]; then
		echo "MesloLGSNFRegular.ttf found!"
	else
		echo "MesloLGSNFRegular.ttf not found! Copying it..."
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
		print_green "ZSH_THEME changed!"
	fi
}

function set_p10k_config()
{
	cp $PWD/p10k_bck.zsh $P10K_CONFIG_FILE_PATH
	echo $PWD/p10k_bck.zsh "  " $P10K_CONFIG_FILE_PATH
	print_green "p10k configured / overwritten!"
}

#function to disable the p10k configuration wizard by adding POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true to $HOME/.zshrc if not present
function check_p10k_configuration_wizard()
{
	if grep -q "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" $FILE_ZSHRC; then
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true found! doing nothing..."
	else
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true not found! Creating it..."
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" >> $FILE_ZSHRC
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true created!"
	fi
}

#function to change the default font of vs code to MesloLGS NF
function check_vscode_font()
{
	#copy vs_terminal_config.json to $VS_TERMINAL_CONFIG_PATH
	cp $PWD/vs_terminal_settings.json $VS_TERMINAL_CONFIG_PATH
	echo $PWD/vs_terminal_settings.json $VS_TERMINAL_CONFIG_PATH
}

#in

function finish()
{
	print_silent ciao
	print_silent "zsh configured!"
	# clear
	print_bold_green "All done! Enjoy your new shell!"
	# exec zsh
}

#pass every argument to the function check_arg
check_argv $@
# set_fonts
# check_brew
# check_vimrc
# git_config
# download_ohmyzsh
# copy_zsh
# copy_vimrc
# check_zsh_autosuggestions
# check_zsh_powerlevel10k
# check_zsh_theme
# check_vscode_font
# set_p10k_config
# check_p10k_configuration_wizard
# check_vscode_font
finish
