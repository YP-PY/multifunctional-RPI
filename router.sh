#!/bin/bash

#update the iptables
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

#install app to make the iptables persistent and install vlan
sudo apt install -y iptables-persistent vlan

#save the iptables
sudo sh -c "iptables-save > /etc/iptables/rules.v4" 
#enable ipv4 forwading
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

#set the name type for vlans
sudo vconfig set_name_type DEV_PLUS_VID_NO_PAD

#install pihole
curl -L https://install.pi-hole.net | sudo bash
