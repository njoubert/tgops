# `otto1-robot`: Autonomous Vehicle Computer for TechnoGecko


Organization:
* Base OS providing networking.
* Virtual Machine for all the autonomy work. Keep the ROS environment separate from the base machine, and identical to VM we run on developer machines. 


Provisioning scripts for individual applications are provided. See `provision_xxx.sh` files.x

# On Host Zotac Machine

## Manual Provisioning 2019/06/14

Install Ubuntu 18.01.1 LTS Bionic.

### Install basic dev tools and configuration

Run `sudo ./provision_dev_base.sh`
* vim, emacs, git
* tmux, with configuration and plugins

### Setup bash dotfiles 

Create `~/Code/dotfiles`
Move and link `.bashrc` here. 
Make some pretty prints to give information about device.

## Network 


### Manually Configure Ethernet Interfaces

Manually configure ethernet interfaces through Ubuntu NetworkManager GUI.
Configuration auto-saved in `/etc/NetworkManager/system-connections`
In the future we might prefer to write a manual `/etc/network/interfaces` file
```
10.254.1.32/16,10.254.1.1
10.1.32.100/24,10.1.32.1
```
### Provision basic setup

Run `sudo ./provision_network.sh`:
* changes hostname
* disables ipv6
* enables ipv4 forwarding
* installs dhcp server

### Configure DHCP Server

Edit `/etc/default/isc-dhcp-server` and add only the autonomy interface to the list of interfaces
Edit `/etc/dhcp/dhcpd.conf`
Restart service `sudo service isc-dhcp-server restart`

* To see logs: `journalctl -u isc-dhcp-server`
* To see current leases `cat /var/lib/dhcp/dhcpd.leases`

# On your Local Dev Machine

Add this to your `.ssh/config`:

```
host robot-otto1 192.168.0.52
    Hostname 192.168.0.52
    Port 22
    User gecko
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
    IdentityFile ~/.ssh/id_rsa
```

Copy your dev machine's public key to otto's authorized keys:

`cat ~/.ssh/id_rsa.pub | ssh gecko@192.168.0.52 "cat >> .ssh/authorized_keys"`

Now you can easily ssh in with 

`ssh robot-otto1`

# Inside VM for Autonomous System

Virtualbox:
* Switch the default network from `NAT` to `Bridged` to expose this VM to the broader network.

* Basic Tools (vim, git, emacs, tmux)
	* `sudo ./provision_dev_base.sh`
* SSH Access
	* `sudo ./provision_services.sh`
* Shared Folder for remote text editing with Sublime

* Screen Sharing


