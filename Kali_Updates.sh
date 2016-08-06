#!/bin/bash
# Author: Steven Burnell
# Description: Kali Linux customization and update script for Red-Team Operators
#              to make life easier. Run this script on a fresh Kali install or before
#              going on a mission. Don't forget to check for newer versions of cobalt strike!
#              https://www.cobaltstrike.com/download
# Last updated: 05 AUG 2016

source $INSTALL_DIR/functions.sh

# Check active resolution
# I might detect resolution and change it only if it's the default 800x600, because that's annoyingly small.
current_resolution=$(xrandr --current | head -1 | cut -d"," -f2 | sed 's/\ //g' | sed 's/current//g')
if [ "$current_resolution" == "800x600" ]; then
	echo "currently set to 800x600"
fi

# Enable root auto-login without password prompt
sed -i 's/.*AutomaticLoginEnable =.*/AutomaticLoginEnable = true/' /etc/gdm3/daemon.conf
sed -i 's/.*AutomaticLogin =.*/AutomaticLogin = root/' /etc/gdm3/daemon.conf

# Updates the GRUB timeout to be 1 second instead of 5 to improve boot time
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub

# Unlock custom aliases
sed -i 's/^#alias ll=/alias ll=/' ~/.bashrc
sed -i 's/^#alias la=/alias la=/' ~/.bashrc
sed -i 's/^#alias l=/alias l=/' ~/.bashrc

# Create Cobalt Strike Addon directory and setup git clones
if ! [ -d /opt/cobaltstrike-addons ]; then 
	mkdir /opt/cobaltstrike-addons
fi

# CobaltStrike's "Cortana" scripts (renamed to Aggressor Scripts in Cobalt Strike 3.x)
if [ -d /opt/cobaltstrike-addons/cortana-scripts ]; then
	cd /opt/cobaltstrike-addons/cortana-scripts
	git pull
else
	cd /opt/cobaltstrike-addons/
	git clone https://github.com/rsmudge/cortana-scripts.git
fi

# CobaltStrike's Malleable-C2-Profiles
if [ -d /opt/cobaltstrike-addons/Malleable-C2-Profiles ]; then
	cd /opt/cobaltstrike-addons/Malleable-C2-Profiles
	git pull
else
	cd /opt/cobaltstrike-addons/
	git clone https://github.com/rsmudge/Malleable-C2-Profiles.git
fi

# Veil-Evasion
if [ -d /opt/Veil-Evasion ]; then
	cd /opt/Veil-Evasion
	git pull
	#cd setup
	#./setup.sh -s
else
	cd /opt/
	git clone https://github.com/Veil-Framework/Veil-Evasion.git
	cd Veil-Evasion/setup
	#./setup.sh -s
fi

# Ensure that scripts can be run by double-clicking it from the desktop
gsettings set org.gnome.nautilus.preferences executable-text-activation ask

# Disable the locking screensaver
gsettings set org.gnome.desktop.screensaver lock-enabled false

# Disable turning off the display due to inactivity
#gsettings set org.gnome.settings-daemon.plugins.power sleep-display-ac 0
#gsettings set org.gnome.settings-daemon.plugins.power sleep-display-battery 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0

# A couple other UI tweaks
gsettings set org.gnome.desktop.interface clock-show-date true

# Create symlinks on the desktop for helpful shortcuts
for script_name in \
start_cobaltstrike.sh \
start_cs_teamserver.sh \
install_cobalt_strike.sh \
RedCell-Kali.sh \
Cobalt\ Strike\ Docs \
Phishing\ Templates
do
	if [ -e "/$USER/Desktop/$script_name" ]; then
		rm -f "/$USER/Desktop/$script_name"
	fi
	
	ln -s "$INSTALL_DIR/$script_name" "/$USER/Desktop/$script_name"
done

# Install Oracle's Java 8 for Cobalt Strike
if ! [ -f /etc/apt/sources.list.d/webupd8team-java.list ]; then
	cat >/etc/apt/sources.list.d/webupd8team-java.list<< EOF
deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main 
EOF

	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 
	apt-get update
	apt-get install oracle-java8-installer
	#rm -f /etc/apt/sources.list.d/1
fi
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 
apt-get update
apt-get install oracle-java8-installer

# Tell Kali Linux to use Java 8 by default for CobaltStrike
update-java-alternatives -s java-8-oracle

# Update metasploit
service postgresql start && msfdb init
msfdb start && msfdb stop
msfupdate

# Configure postgresql to start on boot
update-rc.d postgresql enable

# Install extra packages
apt-get install \
rarcrack \
vmfs-tools \
zerofree \
ntpdate

# Ensure ntp service runs at bootup
update-rc.d ntp enable

# Update packages
apt-get update && apt-get upgrade && apt-get autoremove
apt-get dist-upgrade && apt-get autoremove

#Clean up package repo
#apt-get clean

echo ""
echo ""
echo ""
pause 'Press [Enter] key to continue...'


#How to run zerofree and punch zeros from vmware player
#1) Boot into single user mode. (From grub menu, press 'E' to edit) and add "single" to the end of the line that ends with "quiet"
#2a) Run the script that does steps 2b, 3, and 4: ./zerofree.sh
#2b) mount -o remount,ro /
#3) zerofree /dev/sda1
#4) shutdown now -h
#5) from vmware, edit virtual machine settings, select the disk, then click "compact disk".
