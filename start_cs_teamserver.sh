#!/bin/bash
source /etc/redcell-kali/RedCell-Kali.conf
source $INSTALL_DIR/functions.sh

# Configure these variables
# Nevermind, I decided to do it for you, change them if you like to do things manually.
IPAddress=$(ifconfig -a eth0 | grep "inet " | cut -d":" -f 2 | cut -d" " -f 1)
Password="hacktheplanet"
CobaltStrikeDir=/opt/cobaltstrike

## Check to see that Cobalt Strike has been installed
if ! [ -e $CobaltStrikeDir ]; then
	echo "You need to run the 'install_cobalt_strike.sh' script first"
	pause 'Press [Enter] key to quit...'
	exit
fi


# Display Teamserver Info for quick reference
echo "Teamserver IP: $IPAddress"
echo "Teamserver password: $Password"
echo "Cobalt Strike Working Directory: $CobaltStrikeDir"

if [ -z "$IPAddress" ] || [ -z "$Password" ]; then
	echo "Could not determine IP Address or teamserver password. Edit this script, ensure you have an IP address on eth0, and/or ensure the command at the top is actually finding your IP"
	pause 'Press [Enter] key to continue...'
else
	echo "Press CTRL+C to stop the server..."
	cd $CobaltStrikeDir
	./teamserver $IPAddress $Password
	echo ""	
	pause 'Done hacking the Gibson so soon?'
fi
