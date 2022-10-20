#!/bin/zsh

# Simple script to add to ~/.zshrc and ~/.bashrc a OPENAI or DJANGO key
# Make sure to have zsh installed!
# The key is passed as first argument or entered from stdin

DJANGO_CHECK="django-"
OPENAI_CHECK="sk-"

function ask_to_add_key()
{
    echo -n "Please enter your Django or OpenAI secret key: "
    read KEY
    if [[ $KEY == $DJANGO_CHECK* ]]
    then
        KEY_TYPE=1
        break
    elif [[ $KEY == $OPENAI_CHECK* ]]
    then
        KEY_TYPE=2
        break
    else
        echo "The key is not a Django key or an OpenAI key"
    fi
}

# If $1 is empty, the script will ask for the key
if [ -r $1 ]
then
    ask_to_add_key
else
    KEY=$1
    #if key starts with DJANGO_CHECK, it's a django key
    #if key starts with OPENAI_CHECK, it's an openai key
    if [[ $KEY == $DJANGO_CHECK* ]]
    then
        KEY_TYPE=1
    elif [[ $KEY == $OPENAI_CHECK* ]]
    then
        KEY_TYPE=2
    else
        echo "The key is not a Django key or an OpenAI key"
    fi
fi

DJANGO_KEY="DJANGO_KEY"
OPENAI_KEY="OPENAI_API_KEY"

# Loop to ask for the key again if it is not valid
while [[ $KEY_TYPE != 1 && $KEY_TYPE != 2 ]]
do
    #write that in red
    echo "\e[31mThe key type is not valid, please try again\e[0m"
    ask_to_add_key
done

if [ $KEY_TYPE = "1" ]
then
    KEY_NAME=$DJANGO_KEY
    KEY_CHECK=$DJANGO_CHECK
else
    KEY_NAME=$OPENAI_KEY
    KEY_CHECK=$OPENAI_CHECK
fi

# Check if the key is valid, by checking if it starts with django-
# Use a for loop to ask for the key again if it is not valid
while [[ $KEY != ${KEY_CHECK}* ]]
do
    echo "The key is not valid, please try again"
    echo -n "Please enter your ${KEY_NAME} secret key: "
    read KEY
done

function backup_old_key()
{
    # Create a file called .old_keys in the home directory to store old keys
    if [ ! -f ~/.old_keys ]
    then
        touch ~/.old_keys
    fi
    # Check if the key is already in the file
    if ! grep -q $KEY ~/.old_keys
    then
        # If not, add it to the file
        # echo a timestamp and the key
        echo "[$(date)] $KEY_NAME = '$KEY'" >> ~/.old_keys
    fi
}

function add_key ()
{
    if ! grep -q $KEY_NAME $1; then
        echo "$KEY_NAME not found in $1, adding it...\n"
        echo "export $KEY_NAME='$KEY'" >> $1
        #echo with green color key added!
        echo -e "\e[32mKey added!\e[0m\n"
    else
        echo "$KEY_NAME found in $1, make sure to check if it's a functioning key!\n"
        #ask if the user wants to change the key
        echo -n "Do you want to change the key? [y/n]: "
        read CHANGE
        if [ $CHANGE = "y" ]
        then
            backup_old_key
            #replace the key with the new one
            if [ $KEY_TYPE = "1" ]
            then
                sed -i.old '/DJANGO/d' $1
            else
                sed -i.old '/OPENAI/d' $1
            fi
            echo "export $KEY_NAME='$KEY'" >> $1 
            #echo with green color key changed!
            echo -e "\e[32mKey changed!\e[0m\n"
        else
            #print with yellow color key not changed
            echo -e "\e[33mKey not changed\e[0m\n"
        fi
    fi
}

add_key ~/.zshrc
add_key ~/.bashrc

source ~/.zshrc; source ~/.bashrc; exec zsh