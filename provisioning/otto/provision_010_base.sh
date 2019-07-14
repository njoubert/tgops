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
. helper_preamble.sh
. helper_functions.sh

###### MEAT AND POTATOES ######

# Link .bashrc and .bach_profile dotfiles
echo_section "Linking bash dotfiles"
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/bash_profile.sh $HOME/.bash_profile
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/bashrc.sh $HOME/.bashrc

# Install basic editors
echo_section "Installing emacs, vim, git"
sudo apt install emacs vim git

# Install tmux and symlink configs
echo_section "Installing tmux"
sudo apt-get install tmux=2.6-3ubuntu0.1
echo_section "Symlinking tmux configuration files"
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/tmux.conf $HOME/.tmux.conf
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/tmux $HOME/.tmux

# Linking git config files
echo_section "Linking git config files"
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/gitconfig $HOME/.gitconfig  
