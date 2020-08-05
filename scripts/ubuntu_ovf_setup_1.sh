#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
echo 'yes'

set -x
set -e

# cat > "/etc/apt/sources.list" << EOF
# deb http://ubuntu.univ-nantes.fr/ubuntu/ bionic main restricted universe multiverse
# deb http://ubuntu.univ-nantes.fr/ubuntu/ bionic-updates main restricted universe multiverse
# deb http://ubuntu.univ-nantes.fr/ubuntu/ bionic-backports main restricted universe multiverse
# deb http://ubuntu.univ-nantes.fr/ubuntu/ bionic-security main restricted universe multiverse
# EOF

# Perform an update and full upgrade.
# sudo rm -rf /var/lib/apt/lists/*
# apt-get update
# apt-get -y --force-yes dist-upgrade

# Install necessary libraries for guest additions and ansible NFS Share
# Also install curl, comes with most "cloud images" distributed by Ubuntu by default
# TODO: some of this is already installed via ../http/bionic_preseed_template.cfg on bionic? deduplicate?
# apt-get install -y --force-yes build-essential curl dkms linux-headers-$(uname -r) nfs-common

# Setup sudo to allow no-password sudo for "admin"
echo 'yes'
groupadd -r admin
echo 'yes'
usermod -a -G admin ansible
echo 'yes'
cp /etc/sudoers /etc/sudoers.orig
echo 'yes'
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
echo 'yes'
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
echo 'yes'
# TODO: safe on non-bionic distro versions?
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Change ansible and root user shells to real bash.
chsh -s $(which bash) ansible
chsh -s $(which bash) root

# Once we have an OVF, the network comes online as eth1 not eth0.
# The default /etc/network/interfaces has eth0.
# Swap eth0 for eth1 so it boots a bit cleaner.
#sed -i -e 's/eth0/eth1/' /etc/network/interfaces
# Cleaner network setup? test it.

#use old style interface names
# if [ "$(lsb_release -c -s)" == "xenial" ]
# then
#   ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
# fi

# cat > "/etc/network/interfaces" << EOF
# # Loopback
# auto lo
# iface lo inet loopback
# # Optional interfaces (if they exist)
# # eth0
# allow-hotplug eth0
# iface eth0 inet dhcp
# # eth1
# allow-hotplug eth1
# iface eth1 inet dhcp
# EOF

# Purge any old VirtualBox Guest Additions installed via apt.
# apt-get -y -q purge virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# Disable daily apt unattended updates.
# TODO: safe on non-bionic distro versions?
# echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# Reboot so we can start the next provisioner on our latest kernel.
# reboot
# sleep 60
# service networking stop
