#!/bin/zsh
#DO NOT RUN THIS SCRIPT DIRECTLY, RUN config.sh INSTEAD

FILE_ZSHRC="$HOME/.zshrc"
FILE_ZSHRC_TXT="zshrc.txt"
FILE_VIMRC="$HOME/.vimrc"
FILE_VIMRC_TXT="vimrc.txt"
P10K_CONFIG_FILE_PATH="$HOME/.p10k.zsh"
VS_TERMINAL_CONFIG_PATH="$HOME/Library/Application Support/Code/User/settings.json"

#function to install vim if not installed

function install_vim(){
	if [ -d "~/.vimrc" ]; then
		echo "Installing vim"
		brew install vim
		echo "Installed!"
	else
		echo "Hai vim installato! Doing nothing..."
	fi
}

#funzione to check if vim config is already installed, if not, install it
function check_vimrc() {
	if [ -f $FILE_VIMRC ]; then
		echo "File $FILE_VIMRC found!"
	else
		echo "File $FILE_VIMRC not found! Creating it..."
		touch $FILE_VIMRC
		echo "File $FILE_VIMRC created!"
	fi
}

#function to change git config to use the default git config
function git_config() {
	git config --global user.name "dani-MacOS"
	git config --global user.email "sio2guanoeleo@gmail.com"
	echo "Git configured!"
}

#funzione che legge linea per linea il file FILE_ZSHRC_TXT e lo copia in FILE_ZSHRC, se la linea è presente nel file FILE_ZSHRC, non fa niente
function copy_zsh() {
	while read line; do
		if grep -q "$line" $FILE_ZSHRC; then
			echo "$line found! doing nothing..."
		else
			echo $line >> $FILE_ZSHRC
		fi
	done < $FILE_ZSHRC_TXT
}

#funzione che legge linea per linea il file FILE_VIMRC_TXT e lo copia in FILE_VIMRC, se la linea è già presente, non fa niente
function copy_vimrc() {
	while read line; do
		if grep -q "$line" $FILE_VIMRC; then
			echo "$line found! doing nothing..."
		else
			echo $line >> $FILE_VIMRC
		fi
	done < $FILE_VIMRC_TXT
}

#funzione che controlla se ~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions è presente, se non lo è, lo crea
#lo crea usando git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
function check_zsh_autosuggestions() {
	if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
		echo "zsh-autosuggestions found! doing nothing..."
	else
		echo "zsh-autosuggestions not found! Creating it..."
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		echo "zsh-autosuggestions created!"
	fi
}

#function to check if zsh theme powerlevel10k is present, if not, it creates it
#it creates it using git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
function check_zsh_powerlevel10k() {
	if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
		echo "powerlevel10k found! doing nothing..."
	else
		echo "powerlevel10k not found! Creating it..."
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
		echo "powerlevel10k created!"
	fi
}

#function to check if in the file $HOME/.zshrc there is the line containing the string "ZSH_THEME="robbyrussell""
#then delete that line and create a new one containing "ZSH_THEME="powerlevel10k/powerlevel10k""
function check_zsh_theme() {
	if grep -q "ZSH_THEME=\"robbyrussell\"" $FILE_ZSHRC; then
		#change from robbyrussell to powerlevel10k
		sed -i '' "s/robbyrussell/powerlevel10k\/powerlevel10k/" $FILE_ZSHRC
		echo "ZSH_THEME changed!"
	fi
}

function set_p10k_config() {
	cp $PWD/p10k_bck.zsh $P10K_CONFIG_FILE_PATH
	echo $PWD/p10k_bck.zsh "  " $P10K_CONFIG_FILE_PATH
	echo "p10k configured!"
}

#function to disable the p10k configuration wizard by adding POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true to $HOME/.zshrc if not present
function check_p10k_configuration_wizard() {
	if grep -q "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" $FILE_ZSHRC; then
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true found! doing nothing..."
	else
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true not found! Creating it..."
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" >> $FILE_ZSHRC
		echo "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true created!"
	fi
}

#function to change the default font of vs code to MesloLGS NF
function check_vscode_font() {
	#copy vs_terminal_config.json to $VS_TERMINAL_CONFIG_PATH
	cp $PWD/vs_terminal_settings.json $VS_TERMINAL_CONFIG_PATH
	echo $PWD/vs_terminal_settings.json $VS_TERMINAL_CONFIG_PATH
}

function finish() {
	source $HOME/.zshrc
	clear
	echo "All done! Enjoy your new shell!"
}

# install_vim
# check_vimrc
# git_config
# copy_zsh
# copy_vimrc
# check_zsh_autosuggestions
# check_zsh_powerlevel10k
# check_zsh_theme
# check_vscode_font
# set_p10k_config
# check_p10k_configuration_wizard
check_vscode_font
finish
