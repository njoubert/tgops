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

# Configure DHCP for interfaces
echo_section "Configuring DHCP Server"

# Is DHCP already configured?
if ! grep -q  "^INTERFACESv4=\"[^\"].*\"" /etc/default/isc-dhcp-server; then
  echo "No configuration yet"

  # Select interface
  NUM_IFACES=$(ip addr | grep "^[0-9]*:" | cut -d: -f1 | sed '$!d')
  ip addr
  
  read_and_confirm DHCP_IFACE_NUM "Which interface do you want to configure for DHCP [1-$NUM_IFACES]?" 1
  if [ $DHCP_IFACE_NUM -gt $NUM_IFACES ]; then
    echo_error_and_exit "Specified an interface outside the legal range"
  fi
  DHCP_IFACE=$(ip addr | grep "^$DHCP_IFACE_NUM" | tr -d ' ' | cut -d: -f 2)
  read -p "We are setting up DHCP on interface $DHCP_IFACE, is that what you want? [Yn] " -n 1 -r
  echo ""
  if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "We're bialing out"
    exit
  fi
  # Write config to /etc/default/isc-dhcp-server
  DHCP_SERVER_CONFIG_STR="$(cat <<EOF
INTERFACESv4="$DHCP_IFACE"
EOF
)"
  
  write_to_file_if_not_exist /etc/default/isc-dhcp-server $DHCP_SERVER_CONFIG_STR

  # Write config to /etc/dhcp/dhcpd.conf
  read_and_confirm SUBNET "What is the subnet address?" "10.1.32.0"
  read_and_confirm NETMASK "What is the netmask?" "255.255.255.0"
  read_and_confirm RANGE_S "What is the DHCP range start?" "10.1.32.200"
  read_and_confirm RANGE_E "What is the DHCP range end?" "10.1.32.239"
  read_and_confirm GATEWAY "What is the gateway?" "10.1.32.100"
  read_and_confirm BCAST "What is the broadcast address?" "10.1.32.255"
  DHCP_LEASE_CONFIG_STR="$(cat <<EOF
authoritative;
subnet $SUBNET netmask $NETMASK {
  range $RANGE_S $RANGE_E;
  option subnet-mask $NETMASK;
  option routers $GATEWAY;
  option broadcast-address $BCAST;
  default-lease-time 3600;
  max-lease-time 604800;
}
EOF
)"

   echo -e "$SCRIPT_SIG" >> /etc/dhcp/dhcpd.conf
   echo -e "$DHCP_LEASE_CONFIG_STR" >> /etc/dhcp/dhcpd.conf
   echo -e "$SCRIPT_SIG_END" >> /etc/dhcp/dhcpd.conf
   
  systemctl restart isc-dhcp-server
else
  echo_warn_and_continue "DHCP already configured, skipping..."
fi
echo "+ DHCP server status:"
systemctl status isc-dhcp-server | grep Active

exit


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

