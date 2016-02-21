#!/usr/bin/env bash

# Some colors
yellow='\033[1;33m'
NC='\033[0m'

# Required dependencies
sudo apt-get -y install git build-essential autoconf
sudo apt-get -y update

# Check if exists and install
dpkg-query -l "chefdk" | grep -q ^.i
if [ $? -ne 0 ]; then
	echo -e "${yellow}Downloading ChefDK${NC}"
	export CHEFDK_INSTALLER=chefdk_0.10.0-1_amd64.deb
	sudo wget -nv -N -P /var/cache/downloads https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/$CHEFDK_INSTALLER
	echo -e "${yellow}Installing ChefDK${NC}"
	sudo dpkg -i /var/cache/downloads/$CHEFDK_INSTALLER
	chef -v

	# Configure system Ruby
	echo -e "${yellow}Configuring System Ruby${NC}"
	echo 'eval "$(chef shell-init bash)"' | sudo tee --append /etc/profile > /dev/null
	source /etc/profile
	which ruby
fi

# Install dependencies
dpkg-query -l "vagrant" | grep -q ^.i
if [ $? -ne 0 ]; then
	## Vagrant
	echo -e "${yellow}Downloading Vagrant${NC}"
	export VAGRANT_INSTALLER=vagrant_1.7.2_x86_64.deb
	sudo wget -nv -N -P /var/cache/downloads https://dl.bintray.com/mitchellh/vagrant/$VAGRANT_INSTALLER
	echo -e "${yellow}Installing Vagrant${NC}"
	sudo dpkg -i /var/cache/downloads/vagrant_1.7.2_x86_64.deb
	vagrant -v
fi

# Remove installer
rm -f /var/cache/downloads/$CHEFDK_INSTALLER
rm -f /var/cache/downloads/$VAGRANT_INSTALLER
