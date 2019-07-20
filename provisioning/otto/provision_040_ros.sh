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
NO_SUDO=True
. helpers.sh

echo_section "Installing dev tools"
sudo apt-get install build-essential python-pip python-tox pandoc

echo_section "Adding ROS packages to apt"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo_section "Installing ros-melodic-desktop-full"
sudo apt update
sudo apt install ros-melodic-desktop-full

echo_section "Initializing ros"
sudo rosdep init
rosdep update
#echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc # This is already in there
source ~/.bashrc

echo_section "Installing ancilliary build tools etc"
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential
