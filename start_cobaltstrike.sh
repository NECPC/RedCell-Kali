#!/bin/bash

function pause(){
	read -p "$*"
}

## Check to see that Cobalt Strike has been installed
if ! [ -e /root/Desktop/cobaltstrike ]; then
	echo "You need to run the 'install_cobalt_strike.sh' script first"
	pause 'Press [Enter] key to quit...'
	exit
fi

## For Cobalt Strike Trial install:
cd /root/Desktop/cobaltstrike

## For licensed Cobalt Strike install:
#cd /usr/share/cobaltstrike

./cobaltstrike


