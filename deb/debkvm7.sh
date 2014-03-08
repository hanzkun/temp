#!/bin/sh

# initialisasi var
#export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update
apt-get -y install wget curl

# set time GMT +7
#ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;

# install webserver
#apt-get -y install nginx php5-fpm php5-cli

# install essential package
#echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon nano iptables chkconfig nethogs vnstat screen apt-file ngrep mtr git snmp snmpd unzip
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
#vnstat -u -i eth0
service vnstat restart

# install screenfetch
cd
wget --no-check-certificate "https://github.com/KittyKatt/screenFetch/raw/master/screenfetch-dev"
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile


# setting port ssh
cd
sed -i '/Port 22/a Port 443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 80' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/#DROPBEAR_PORT=22/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 143"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.670_all.deb"
dpkg --install webmin_1.670_all.deb;
apt-get -y -f install;
rm /root/webmin_1.670_all.deb
service webmin restart

#swap memory
dd if=/dev/zero of=/swapfile bs=1024 count=524288
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile
swapon /swapfile
sed -i '$ i\swapon /swapfile' /etc/rc.local
sed -i '$ i\swapon /swapfile' /etc/rc.d/rc.local

# sekrip
cd
wget -O speedtest_cli.py "https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py"
wget -O bench-network.sh "https://raw.github.com/arieonline/autoscript/master/conf/bench-network.sh"
wget -O ps_mem.py "https://raw.github.com/pixelb/ps_mem/master/ps_mem.py"
wget -O limit.sh "http://172.245.223.98/volcanos/limit.sh"
curl https://gist.githubusercontent.com/hanzkun/05f30bc0198fd3fba036/raw/44a22c1fa328884a5b8659389bb4a2d43cec1e31/viewlogin.sh > viewlogin.sh
curl http://172.245.223.98/volcanos/limit.sh > user-limit.sh
sed -i '$ i\screen -AmdS limit /root/limit.sh' /etc/rc.local
sed -i '$ i\screen -AmdS limit /root/limit.sh' /etc/rc.d/rc.local
chmod +x bench-network.sh
chmod +x speedtest_cli.py
chmod +x ps_mem.py
chmod +x viewlogin.sh
chmod +x user-limit.sh
chmod +x limit.sh
 
# cron
service crond start
chkconfig crond on
 
# finalisasi
service vnstat restart
#service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service webmin restart
chkconfig iptables on
chkconfig squid on
 
 
# info
clear
echo "==============================================="
echo ""
echo "Service"
echo "-------"
echo "OpenSSH  : 22, 143, 80"
echo "Dropbear : 109, 443"
echo "Swap memory 512MB | to check: free -m"
echo "==============================================="
echo "Script"
echo "------"
echo "./ps_mem.py"
echo "./speedtest_cli.py --share"
echo "./bench-network.sh"
echo "./viewlogin.sh"
echo "./user-limit.sh 2"
echo "Reboot your VPS!"
echo "blablablbala" | tee log-install.txt
