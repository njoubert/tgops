# `otto`: Provisitioning the Autonomous Vehicle Controller for TechnoGecko

Organization:
* Base OS providing networking.
* Virtual Machine for all the autonomy work. Keep the ROS environment separate from the base machine, and identical to VM we run on developer machines. 

Provisioning scripts for individual applications and areas are provided.

# Preamble: Credentials

**GITLAB**

We have a separate gitlab account for access from the autonomous computers

```
name:  Otto TechnoGecko
email: ottotechnogecko@gmail.com
user:  ottotechnogecko
pass:  &n5SVjR!
```

**GMAIL**

```
ottotechnogecko@gmail.com
&n5SVjR!
```

# Setup: On Host Zotac Machine

## Step 1: Install Ubuntu and Connect to Internet (temporarily)

Install Ubuntu 18.04 LTS Bionic.
Connect to the internet, ideally through WiFi/

## Step 2: Transfer the `tgops` repository to your new machine

I just copy the repository over, or download from the website
**Place it in a location you will keep it. We will be creating symlinks into this folder**.

## Step 3: Install base environment and configuration

Run `sudo ./provision_010_base.sh`
* Links `bashrc.sh` and `bash_profile.sh` dotfiles
* Installs vim, emacs, git, tmux
* Configures tmux
* Configures git for user `ottotechnogecko@gmail.com`

## Step 4: Configure network 

### Manually Configure Ethernet Interfaces

Manually configure ethernet interfaces through Ubuntu NetworkManager GUI.
Configuration auto-saved in `/etc/NetworkManager/system-connections`
In the future we might prefer to write a manual `/etc/network/interfaces` file
```
10.254.1.32/16,10.254.1.1
10.1.32.100/24,10.1.32.1
```
### Provision network

Run `sudo ./provision_020_network.sh`:
* changes hostname
* disables ipv6
* enables ipv4 forwarding
* installs dhcp server
* prompts you to configure DHCP server

* To see logs: `journalctl -u isc-dhcp-server`
* To see current leases `cat /var/lib/dhcp/dhcpd.leases`


### Provision Remote access

Run `sudo ./provision_030_remote_access.sh`:
* installs ssh
* generates ssh keys
* configures Vino for remote VNC access, with password `techno`



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
	* `sudo ./provision_010_base.sh`
* SSH Access, VNC access, SMB access
	* `sudo ./provision_020_network.sh`



