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
. helper_preamble.sh

###### MEAT AND POTATOES ######

# Link .bashrc and .bach_profile dotfiles
echo "+ Symlinking bashrc and bash_profile"
BASHRC_INCLUDE="$(cat <<EOF
$SCRIPT_SIG
if [ -f $PROVISION/dotfiles/bashrc.sh ]; then
        source $PROVISION/dotfiles/bashrc.sh
fi
### END
EOF
)"
echo -e "$BASHRC_INCLUDE" >> $HOME/.bashrc

BASHPROFILE_INCLUDE="$(cat <<EOF
$SCRIPT_SIG
if [ -f $PROVISION/dotfiles/bash_profile.sh ]; then
        source $PROVISION/dotfiles/bash_profile.sh
fi
### END
EOF
)"
echo -e "$BASHPROFILE_INCLUDE" >> $HOME/.bash_profile

exit

# Install basic editors
echo "+ Installing emacs, vim, git"
sudo apt install emacs vim git

# Install tmux and symlink configs
echo "+ Installing tmux"
sudo apt-get install tmux=2.6-3ubuntu0.1
echo "+ Symlinking tmux configuration files"
ln -s $PROVISION/dotfiles/tmux.conf $HOME/.tmux.conf
ln -s $PROVISION/dotfiles/tmux $HOME/.tmux

