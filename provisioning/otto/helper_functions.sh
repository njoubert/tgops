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

# Usage:
# 	echo "+ Linking X files"
# 	link_if_not_already_link_abort_if_file SRC DEST
link_if_not_already_link_abort_if_file() {
	local SRC=${1}
	local DST=${2}
	if [ "$#" -ne 2 ]; then
		echo "   ERROR: link_if_not_already_link_abort_if_file(): Requires 2 arguments"
		exit
	fi
	if [[ -L $DST && "$(readlink -- "$DST")" = $SRC ]]; then
		echo "    $DST is already symlinked to the specified file, moving on."
		return 1
	elif [ -f $DST ]; then
		echo "    ERROR: $DST exists already, we're chickening out!"
		exit
	else
		ln -s $SRC $DST
		echo "    done"
	fi
	return 0
}