#!/bin/bash


function check_if_sudo {
	if (( $EUID != 0))
	then echo -e "\e[1;91mRun script with root privileges\e[0m"
	exit
	fi
}

check_if_sudo

#dependencies for Nagios
sudo apt install -y autoconf build-essential wget unzip apache2 apache2-utils php libgd-dev snmp libnet-snmp-perl gettext libssl-dev wget bc gawk dc libmcrypt-dev


#download Nagios and compile it
cd /tmp
wget -O nagios.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar xzf nagios.tar.gz
cd /tmp/nagioscore-nagios-4.4.6/
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all

#install Nagios
sudo make install-groups-users
sudo usermod -a -G nagios www-data
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config
sudo make install-webconf
sudo a2enmod rewrite
sudo a2enmod cgi
echo -e "\e[1;91m Provide a password \e[0m"   
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo systemctl restart apache2

#plugins for Nagios
cd /tmp
wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.3.3/nagios-plugins-2.3.3.tar.gz
tar zxf nagios-plugins.tar.gz
cd /tmp/nagios-plugins-2.3.3
./configure
make
sudo make install

#startup Nagios

sudo systemctl enable nagios
sudo systemctl start nagios

echo -e "\e[1;91mGo to http://localhost/nagios \e[0m"   