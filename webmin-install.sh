#!/bin/bash
sudo su -c "echo 'deb https://download.webmin.com/download/repository sarge contrib'>>/etc/apt/sources.list"
sudo su -c "cd /root ;wget https://download.webmin.com/jcameron-key.asc ; apt-key add jcameron-key.asc"
sudo apt update
sudo apt-get install -y perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python unzip
sudo apt-get install -y webmin
