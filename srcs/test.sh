#!/bin/zsh
function print_manager()
{
	#if $3 exists, it means important mode is activated, so the message will be printed ignoring the silent mode
	if [ -n "$3" ]; then
		if [ "$3" == "important" ] || [ "$3" == "i" ]; then
			#convert $2 to uppercase in zsh
            COLOR=$(echo "$2" | tr '[:lower:]' '[:upper:]')
            echo $COLOR
			printf "${COLOR}$1${RESET_COLOR}"
		fi
	else
	if [ -n "$2" ]; then
		#convert $2 to uppercase
		COLOR=$(echo "$2" | tr '[:lower:]' '[:upper:]')
		#if the silent mode is not activated, print the message with the color
        if [ $SILENT_MODE = false ]; then
            echo -e "${COLOR}$1${RESET_COLOR}"
        fi
	else
	if [ $SILENT_MODE = false ]; then
		echo -e "$1"
	fi
	fi
	fi
}
GREEN='\033[0;32m'
RESET_COLOR='\033[0m'
SILENT_MODE=false
print_manager "ciao" green i