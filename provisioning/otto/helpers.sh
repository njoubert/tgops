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
if [ "$EUID" -ne 0 ]; then 
    echo "ERROR: Please run as root"
    exit
else
    echo "+ root admin privileged detected"
fi

# Global vars
OTTOEMAIL="ottotechnogecko@gmail.com"
PROVISION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_SIG="$(cat <<EOF
 
################################################################################
# TechnoGecko Provisioning Script, $(date) 
# {{{
EOF
)"
SCRIPT_SIG_END="$( cat <<EOF
# }}} TechnoGecko Provisioning Script
################################################################################
EOF
)"

echo_section() {
    echo -e "\e[1;30;102m+ $1\e[0m"
}

echo_error_and_exit() {
    echo -e "\e[30;101mERROR: $1\e[0m"
    exit
}

echo_warn_and_continue() {
    echo -e "\e[30;103mWARN: $1\e[0m"
}

# Usage:
#   echo "+ Linking X files"
#   link_if_not_already_link_abort_if_file SRC DEST
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

# Usage:
#  read_and_confirm VARNAME "Prompt?" "default"
read_and_confirm() {
  local RESULTSVAR=$1
  local PROMPT="$2"
  local DEFAULT="$3"
  if [ "$#" -ne 2 ]; then
    echo_error_and_exit "read_and_confirm requires 2 arguments"
    exit
  fi

  ANSWER="$DEFAULT"
  while true; do
    read -p "$PROMPT [$DEFAULT] " -r
    ANSWER=$REPLY
    if [ -z $ANSWER ]; then
        ANSWER="$DEFAULT"
    fi
    read -p "You typed $ANSWER, is that correct? [Yn] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval $RESULTSVAR="'$ANSWER'"
        break
    fi
  done
}

write_to_file_if_not_exist() {
  local CFG_FILE=$1
  local CFG_STR=$2
  if [ "$#" -ne 2 ]; then
    echo_error_and_exit "write_to_file_if_not_exists requires 2 arguments"
  fi
  if grep -q "^$CFG_STR" $CFG_FILE; then
    echo_warn_and_continue "net.ipv4.ip_forward already set"
  else
    echo -e "$SCRIPT_SIG" >> $CFG_FILE
    echo -e "$CFG_STR" >> $CFG_FILE
    echo -e "$SCRIPT_SIG_END" >> $CFG_FILE
  fi
}
