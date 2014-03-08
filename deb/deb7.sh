#!binbash

# go to root
cd

# disable ipv6
echo 1  procsysnetipv6confalldisable_ipv6
sed -i '$ iecho 1  procsysnetipv6confalldisable_ipv6' etcrc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
#ln -fs usrsharezoneinfoAsiaJakarta etclocaltime

# set locale
sed -i 'sAcceptEnv#AcceptEnvg' etcsshsshd_config
service ssh restart

# set repo
wget -O etcaptsources.list httpsraw.github.comhanzkuntempmasterdebconfsources.list.deb7
wget httpwww.dotdeb.orgdotdeb.gpg
cat dotdeb.gpg  apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba;
apt-get -y --purge remove apache2;
apt-get -y --purge remove sendmail;
apt-get -y --purge remove bind9;

# update
apt-get update; apt-get -y upgrade;

# install webserver
#apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i venet0
service vnstat restart

# install screenfetch
cd
wget httpsgithub.comKittyKattscreenFetchrawmasterscreenfetch-dev
mv screenfetch-dev usrbinscreenfetch
chmod +x usrbinscreenfetch
echo clear  .profile
echo screenfetch  .profile

# install badvpn
cd
wget -O usrbinbadvpn-udpgw httpsraw.github.comhanzkuntempmasterdebconfbadvpn-udpgw
sed -i '$ iscreen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.17300' etcrc.local
chmod +x usrbinbadvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.17300


# setting port ssh
sed -i 'Port 22a Port 443' etcsshsshd_config
sed -i 'Port 22a Port 80' etcsshsshd_config
sed -i 'sPort 22Port  22g' etcsshsshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 'sNO_START=1NO_START=0g' etcdefaultdropbear
sed -i 'sDROPBEAR_PORT=22#DROPBEAR_PORT=22' etcdefaultdropbear
sed -i 'sDROPBEAR_EXTRA_ARGS=DROPBEAR_EXTRA_ARGS=-p 109 -p 143g' etcdefaultdropbear
echo binfalse  etcshells
service ssh restart
service dropbear restart
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O etcsquid3squid.conf http172.245.223.98volcanossquid.conf
sed -i $MYIP2 etcsquid3squid.conf;
service squid3 restart

# install webmin
cd
wget httpprdownloads.sourceforge.netwebadminwebmin_1.670_all.deb
dpkg --install webmin_1.670_all.deb;
apt-get -y -f install;
rm rootwebmin_1.670_all.deb
service webmin restart
service vnstat restart


# finalisasi
service vnstat restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart

# info
clear
echo brumbrumrbumbrum.......  tee log-install.txt
echo ===============================================  tee -a log-install.txt
echo    tee -a log-install.txt
echo Service   tee -a log-install.txt
echo -------   tee -a log-install.txt
echo OpenSSH   22, 80, 443   tee -a log-install.txt
echo Dropbear  109, 143   tee -a log-install.txt
echo Squid3    8080 (limit to IP SSH)   tee -a log-install.txt
echo badvpn    badvpn-udpgw port 7300   tee -a log-install.txt
echo    tee -a log-install.txt
echo Script   tee -a log-install.txt
echo ------   tee -a log-install.txt
echo screenfetch   tee -a log-install.txt
echo SILAHKAN REBOOT VPS ANDA !   tee -a log-install.txt
echo    tee -a log-install.txt
echo ===============================================   tee -a log-install.txt
