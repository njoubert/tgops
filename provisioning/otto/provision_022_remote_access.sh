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

prompt_and_generate_ssh_keys() {
  if [ -f $HOME/.ssh/id_rsa ]; then
    echo_warn_and_continue ".ssh/id_rsa detected. Skipping SSH key generation"
  else
    echo "No .ssh/id_rsa detected!"
    read -p "Would you like to generate SSH keys? [Yn] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      echo "+ Configuring SSH and generating SSH Keys for $OTTOEMAIL with no passphrase"
      ssh-keygen -t rsa -b 4096 -C "$OTTOEMAIL" -f $HOME/.ssh/id_rsa -N ""
      echo "+ Please add your public SSH key to Gitlab, etc."
      echo "+   Contents of ~/.ssh/id_rsa.pub:"
      cat $HOME/.ssh/id_rsa.pub
    fi
  fi
}

###### MEAT AND POTATOES ######

### SSH
# install networking tools and servers
echo_section "Installing openssh-server"
apt install openssh-server

# Get SSH Keys up
echo_section "Generating ssh keys"
prompt_and_generate_ssh_keys

### Remote Desktop

### File Sharing

