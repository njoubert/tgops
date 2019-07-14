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


echo_section() {
	echo -e "\e[1;42m+ $1\e[0m"
}

echo_error_and_exit() {
	echo -e "\e[101mERROR: $1\e[0m"
	exit
}

echo_warn_and_continue() {
	echo -e "\e[43mWARN: $1\e[0m"
}

# Usage:
# 	echo "+ Linking X files"
# 	link_if_not_already_link_abort_if_file SRC DEST
link_if_not_already_link_abort_if_file() {
	local SRC=${1}
	local DST=${2}
	if [ "$#" -ne 2 ]; then
		echo_error_and_exit "   ERROR: link_if_not_already_link_abort_if_file(): Requires 2 arguments"
	fi
	if [[ -L $DST && "$(readlink -- "$DST")" = $SRC ]]; then
		echo_warn_and_continue "    $DST is already symlinked to the specified file, moving on."
	elif [ -f $DST ]; then
		echo_error_and_exit "    ERROR: $DST exists already, we're chickening out!"
	else
		ln -s $SRC $DST
		echo "    done"
	fi
}