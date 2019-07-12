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

###### PREAMBLE ######
. provision_preamble.sh

###### MEAT AND POTATOES ######

# Install basic editors
sudo apt install emacs vim git

# Install tmux and symlink configs
sudo apt-get install tmux=2.6-3ubuntu0.1
ln -s $PROVISION/tmux.conf $HOME/.tmux.conf
ln -s $PROVISION/tmux $HOME/.tmux
