#!/bin/bash
# Copyright (C) 2019 Niels Joubert
# Contact: Niels Joubert <njoubert@gmail.com>
#
# This source is subject to the license found in the file 'LICENSE' which must
# be be distributed together with this source. All other rights reserved.
#
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.


###### INCLUDES ######
. helpers.sh


###
prompt_and_set_hostname() {
  echo "The current hostname is \"$HOSTNAME\""
  read -p "Do you want to change the hostname? [Yn] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    read -p "Please enter new hostname: "
    NEW_HOSTNAME=$REPLY
    read -p "About to change hostname to $NEW_HOSTNAME, continue? [Yn] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      hostnamectl set-hostname $NEW_HOSTNAME
      if [[ $? != 0 ]]; then
        echo "WARNING: Failed to set hostname. Continuing"
      else
        CHECK_HOSTNAME=$(hostnamectl | sed -n -e 's/.*hostname: \(.*\)/\1/p')
        echo "Hostname is now $CHECK_HOSTNAME"
      fi
    else
      prompt_and_set_hostname
    fi  
  fi
}

###### MEAT AND POTATOES ######
# user prompt to set hostname
echo_section "Setting hostname"
prompt_and_set_hostname

# install networking tools and servers
echo_section "Installig net-tools isc-dhcp-server mosh bmon"
apt install net-tools isc-dhcp-server mosh bmon

### setup networking ###
# disable ipv6
echo_section "Disabling IPv6"
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# enable ipv4 routing
echo_section "Enabling IPv4 Routing"
write_to_file_if_not_exist "/etc/sysctl.conf" "net.ipv4.ip_forward=1"
sysctl -w net.ipv4.ip_forward=1

# Disable firewalls. We don't need that on our private network
echo_section "Disabling ufw firewall"
ufw disable

