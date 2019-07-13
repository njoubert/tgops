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

# echo every command, we're being verbose
# set -x

# ensure Ubuntu 18.04
if ! lsb_release -a 2>/dev/null | grep -q "Ubuntu 18.04"; then
    echo "ERROR: Compatible only with Ubuntu 18.04 LTS"
    exit
else
	echo "+ Ubuntu 18.04 Detected"
fi

# only run as root, we're installing stuff
if [ "$EUID" -ne 0 ]
  then echo "ERROR: Please run as root"
  exit
else
	echo "+ root admin privileged detected"
fi

# Global vars
OTTOEMAIL="ottotechnogecko@gmail.com"
PROVISION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_SIG="$(cat <<EOF
 
###
### TechnoGecko Provisioning Script, $(date)
### 
EOF
)"