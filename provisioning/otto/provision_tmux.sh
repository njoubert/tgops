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

# exit when any command fails, we're being conservative
set -e

# only run as root, we're installing stuff
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Global vars
PROVISION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Install necessary items
sudo apt-get install tmux
echo $PROVISION/tmux.conf $HOME/.tmux.conf
echo $PROVISION/tmux $HOME/.tmux