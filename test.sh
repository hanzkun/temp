#!bin/bash

IP=$(wget -qO- ifconfig.me/ip)
Port="8080 80"
#apt-get -y install squid3
#squid without password
#lock only for ip server
mv /etc/squid/squid.conf /etc/squid/squid.conf.backup
wget repo.vpscepat.net/squid.conf
mv squid.conf /etc/squid/squid.conf
sed -i s/123.123.123.123/$IP/g /etc/squid/squid.conf
service squid restart
