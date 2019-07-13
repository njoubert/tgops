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

link_if_not_already_link_abort_if_file() { # $1 is SRC, $2 is DEST 
	# Usage:
	# echo "+ Linking git config files"
	# if is_not_already_link_abort_if_file DEST; then
	# 	ln -s DEST SOURCE 
	# 	echo "    done"
	# fi
	if [ "$#" -ne 2 ]; then
		echo "   ERROR: link_if_not_already_link_abort_if_file(): Requires 2 arguments"
		exit
	fi
	if [ -L $2 ]; then
		echo "    $2 is already a simlink, skipping..."
		return 1
	elif [ -f $2 ]; then
		echo "    ERROR: $2 is a file on disk, we're chickening out..."
		exit
	else
		ln -s $1 $2
		echo "    done"
	fi
	return 0
}