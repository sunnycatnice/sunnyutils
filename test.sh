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
FILE_VIMRC_TXT="./srcs/vimrc.txt"
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

#check by running the command uname if the user is running macOS or Linux
if [ "$(uname)" == "Darwin" ]; then
    print_manager "You're on macOS! Great!" green
else
    print_manager "You are on linux! Great!" green
    exit 1
fi