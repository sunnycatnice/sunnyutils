#!/bin/zsh

# Simple script to add to ~/.zshrc and ~/.bashrc a OPENAI or DJANGO key
# Make sure to have zsh installed!
# The key is passed as first argument or entered from stdin

# If $1 is empty, the script will ask for the key
if [ -r $1 ]
then
    echo -n "Please enter your GENERIC secret key: "
    read KEY
else
    KEY=$1
fi

DJANGO_KEY="DJANGO_KEY"
OPENAI_KEY="OPENAI_API_KEY"

DJANGO_CHECK="django-"
OPENAI_CHECK="sk-"

#ask a user if he wants to add a django key or an openai key
echo "Do you want to add a Django key or an OpenAI key?"
echo "1. Django key"
echo "2. OpenAI key"
echo -n "Please enter 1 or 2: "
read KEY_TYPE
echo "\n"

#use a loop to ask for the key again if it is not valid
while [[ $KEY_TYPE != 1 && $KEY_TYPE != 2 ]]
do
    #write that in red
    echo "\e[31mThe key type is not valid, please try again\e[0m"
    echo "Do you want to add a Django key or an OpenAI key?"
    echo "1. Django key"
    echo "2. OpenAI key"
    echo "   To exit, press Ctrl+C"
    echo -n "Please enter 1 or 2: "
    read KEY_TYPE
    echo "\n"
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
            #print with red color key not changed!
            echo -e "\e[31mKey not changed!\e[0m\n"
        fi
    fi
}

add_key ~/.zshrc
add_key ~/.bashrc

source ~/.zshrc; source ~/.bashrc; exec zsh