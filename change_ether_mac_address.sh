#!/bin/bash

# Simple and very basic/primitive script to change your MAC address
# This may be useful if you are blocked in a specific network

echo "Remember to switch off and on your wifi if the script doesn't work, or run the script again"

if [ -r $1 ]
then
    echo -n "Please enter your phone or any other valid MAC address on your network: "
    read VALIDMAC
else
    VALIDMAC=$1
fi

sudo ifconfig en0 ether $VALIDMAC

# Control to check if this command works
while [[ $? != 0 ]]
do
    echo "The MAC address is not valid, please try again"
    echo -n "Please enter your phone or any other valid MAC address on your network: "
    read VALIDMAC
    sudo ifconfig en0 lladd $VALIDMAC
    #if this is looping more than 2 times, echo a message to switch off and on the wifi
    if [[ $i == 2 ]]
    then
        echo "\e[31mRemember to switch off and on your wifi if the script doesn't work, or run the script again\e[0m"
    fi
done

echo "Your MAC address has been changed to $VALIDMAC!"