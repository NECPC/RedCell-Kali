#!/bin/bash
source /etc/redcell-kali/RedCell-Kali.conf
source $INSTALL_DIR/functions.sh

## Check to see that Cobalt Strike has been installed
if ! [ -e /opt/cobaltstrike ]; then
	echo "You need to run the 'install_cobalt_strike.sh' script first"
	pause 'Press [Enter] key to quit...'
	exit
fi

## For Cobalt Strike Trial install:
cd /opt/cobaltstrike

./cobaltstrike
