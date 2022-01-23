#!/bin/bash

if [ -d "~/.oh-my-zsh" ]; then
	echo "Installing oh my zsh"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo "Installed!"
else
	echo "Hai oh my zsh installato! Doing nothing..."
fi

exec $PWD/srcs/install.sh