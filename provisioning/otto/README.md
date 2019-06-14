# `otto1-robot`: Autonomous Vehicle Computer for TechnoGecko

## Hardware

Ubuntu 18.04.1 LTS Bionic




## Manual Provisioning 2019/06/14

Install Ubuntu 18.01.1 LTS Bionic.

### Configure Ethernet Interfaces

Manually configure ethernet interfaces through Ubuntu NetworkManager GUI.
Configuration auto-saved in `/etc/NetworkManager/system-connections`
In the future we might prefer to write a manual `/etc/network/interfaces` file
```
10.254.1.32/16,10.254.1.1
10.1.32.100/24,10.1.32.1
```
### Install Tools

`sudo apt install net-tools openssh-server tmux mosh emacs vim git`

### change hostname

`sudo hostnamectl set-hostname otto1-robot`

### configure tmux

Copy .tmux.conf from https://raw.githubusercontent.com/njoubert/dotfiles/master/thinkpadx60/tmux.conf

Follow instructions here https://github.com/tmux-plugins/tpm

### Setup bash dotfiles 

Create `~/Code/dotfiles`
Move and link `.bashrc` here. 
Make some pretty prints to give information about device.

### Disable ipv6

```
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

### Enable ip forwarding

This turns Otto into a router. Routes between the autonomy and the external world. We do NOT enable network address translation (also known as IP Masquerading)

Edit `/etc/sysctl.conf`
Set `net.ipv4.ip_forward = 1`

and enable it immediately without having to restats.
`sysctl -w net.ipv4.ip_forward=1`

### Install DHCP server as a courtesy to clients plugging into the autonomy network.

`sudo apt install isc-dhcp-server`

Edit `/etc/default/isc-dhcp-server` and add only the autonomy interface to the list of interfaces
Edit `/etc/dhcp/dhcpd.conf`
Restart service `sudo service isc-dhcp-server restart`

* To see logs: `journalctl -u isc-dhcp-server`
* To see current leases `cat /var/lib/dhcp/dhcpd.leases`



## Installing ROS

From http://wiki.ros.org/melodic/Installation/Source


```bash
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential
```

