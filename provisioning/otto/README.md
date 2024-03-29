# `otto`: Provisitioning the Autonomous Vehicle Controller for TechnoGecko

Organization:
* Base OS providing networking.
* Virtual Machine for all the autonomy work. Keep the ROS environment separate from the base machine, and identical to VM we run on developer machines. 

Provisioning scripts for individual applications and areas are provided.

# Preamble: Credentials

**Ubuntu Login**

All our work assumes you have a `gecko` user with password `techno`, with superuser privileges


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
### Provision network: ipv4 forwarding, dhcp server

Run `sudo ./provision_020_network.sh`:
* changes hostname
* disables ipv6
* enables ipv4 forwarding
* installs dhcp server
* prompts you to configure DHCP server

* To see logs: `journalctl -u isc-dhcp-server`
* To see current leases `cat /var/lib/dhcp/dhcpd.leases`

### Provision Remote access: ssh, vnc, smb

Run `sudo ./provision_030_remote_access.sh`:
* installs ssh
* generates ssh keys
* configures Vino for remote VNC access, with password `techno`
* configures smb to share `/` and `/home/gecko`

### Provision ROS

Run `sudo ./provision_040_ros.sh`

# Setting up development machine

Plug in to the autonomy network and otto will provide you with an IP address through its DHCP server. The IP address that you will receive should be of the form 10.1.32.X.

You should now be able to ssh into otto with user `gecko`. If you run `ssh gecko@10.1.32.100` you will be prompted for a password. Enter `techno`.

To skip the password prompt every time you log in, first setup up an ssh key if you don't already have one using the command:
```
ssh-keygen -t rsa -b 4096 -C "$YOUR_EMAIL_ADDRESS" -f $HOME/.ssh/id_rsa -N ""
```

and then copy over your public key to the host machine:

```
ssh-copy-id -i ~/.ssh/id_rsa.pub gecko@10.1.32.100
```
And enter the password when prompted. Try again to ssh into the machine and you should not be prompted for a password this time.

Edit ~/.ssh/config and add the following stanza to the end of the file:

```
Host otto
    HostName 10.1.32.100
    Port 22
    User gecko
    IdentityFile ~/.ssh/id_rsa
```

This will allow you to ssh into the otto machine by simply typing:
```
ssh otto
```

