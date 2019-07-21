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

###### MEAT AND POTATOES ######

# Link .bashrc and .bach_profile dotfiles
echo_section "Linking bash dotfiles"
mv $HOME/.bashrc $HOME/.bashrc.ORIG
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/bash_profile.sh $HOME/.bash_profile
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/bashrc.sh $HOME/.bashrc

# Install basic editors
echo_section "Installing emacs, vim"
sudo apt install emacs vim 
echo_section "Linking emacs, vim config files"
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/emacs $HOME/.emacs

# Install tmux and symlink configs
echo_section "Installing tmux"
sudo apt-get install tmux=2.6-3ubuntu0.1
echo_section "Symlinking tmux configuration files"
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/tmux.conf $HOME/.tmux.conf
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/tmux $HOME/.tmux

# Linking git config files
echo_section "Installing git"
sudo apt install git gitk
echo_section "Linking git config files"
link_if_not_already_link_abort_if_file $PROVISION/dotfiles/gitconfig $HOME/.gitconfig  
