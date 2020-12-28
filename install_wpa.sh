#!/bin/bash

function check_if_sudo {
if (( $EUID != 0))
then echo -e "\e[1;91mRun script with root privileges\e[0m"
exit
fi
}

check_if_sudo

sudo apt update
sudo apt upgrade

sudo apt-get install hostapd -y


read -p "Interface? [wlan0]: " interface
interface=${interface:-wlan0}


read -p "SSID? [RPI-WIFI]: " SSID
SSID=${SSID:-RPI-WIFI}


read -p "Password? [PASSWORD]: " PSK
PSK=${PSK:-PASSWORD}


sed -i "s/wlan0/$interface/" hostapd.conf 
sed -i "s/RPI-WIFI/$SSID/" hostapd.conf 
sed -i "s/PASSWORD/$PSK/" hostapd.conf 

sudo mv hostapd.conf /etc/hostapd/hostapd.conf

sudo bash -c 'echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd'

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

sudo bash -c 'echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf'
sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
sudo apt-get install -y iptables-persistent


echo -e "\e[1;91mYou will have to change your DHCP settings\e[0m"
read -rsp $'Press any key to continue...\n' -n1 key
echo -e "\e[1;91mYour device will reboot now\e[0m"

sudo systemctl reboot
