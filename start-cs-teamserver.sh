#!/bin/bash

# Configure these variables
# Nevermind, I decided to do it for you, change them if you like to do things manually.
IPAddress=$(ifconfig -a eth0 | grep "inet " | cut -d":" -f 2 | cut -d" " -f 1)
Password="hacktheplanet"
CobaltStrikeDir=/root/Desktop/cobaltstrike
function pause(){
	read -p "$*"
}

## Check to see that Cobalt Strike has been installed
if ! [ -e $CobaltStrikeDir ]; then
	echo "You need to run the 'install_cobalt_strike.sh' script first"
	pause 'Press [Enter] key to quit...'
	exit
fi


# Create Cobalt Strike Addon directory and setup git clones
echo "Teamserver IP: $IPAddress"
echo "Teamserver password: $Password"

if [ -z "$IPAddress" ] || [ -z "$Password" ]; then
	echo "Could not determine IP Address or teamserver password. Edit this script, ensure you have an IP address on eth0, and/or ensure the command at the top is actually finding your IP"
	pause 'Press [Enter] key to continue...'
else
	echo "Cobalt Strike Working Directory: $CobaltStrikeDir"
	echo "Press CTRL+C to stop the server..."
	echo
	echo "Teamserver Connection Info:"
	echo "IP Address: $IPAddress"
	echo "Password: $Password"
	cd $CobaltStrikeDir
	./teamserver $IPAddress $Password
	echo ""	
	pause 'Done hacking the Gibson so soon?'
fi
