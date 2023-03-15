#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- https://icanhazip.com);
clear
echo Fix Cert By Procopas
echo https://t.me/Procopas
sleep 0.5
echo Gassss
sleep 0.5
echo Fix Cert By Procopas
echo https://t.me/Procopas
source /var/lib/wisnucs/ipvps.conf
domain=$(cat /etc/xray/domain)
echo -e "[ ${green}INFO${NC} ] Start " 
sleep 1
Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
if [[ ! -z "$Cek" ]]; then
sleep 1
echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek " 
systemctl stop $Cek
sleep 2
echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
sleep 1
fi
echo -e "[ ${green}INFO${NC} ] Starting renew cert... " 
sleep 2
echo -e "[ ${green}INFO$NC ] Getting acme for cert"
curls acme.sh/acme.sh >/dev/null 2>&1
bash acme.sh --install >/dev/null 2>&1
/root/.acme.sh/acme.sh --upgrade --auto-upgrade >/dev/null 2>&1
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt >/dev/null 2>&1
/root/.acme.sh/acme.sh --issue -d $domain --standalone --force --keylength ec-256 --server letsencrypt
#/root/.acme.sh/acme.sh --issue -d $domain --standalone --force --keylength ec-256 --server letsencrypt --listen-v6
/root/.acme.sh/acme.sh --installcert -d $domain --ecc --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key
chmod 644 /etc/xray/xray.key
echo -e "[ ${green}INFO${NC} ] Renew cert done... "
sleep 5
rm acme.sh >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Renew cert done... "
systemctl restart xray
systemctl restart nginx
systemctl enable ntls
systemctl restart ntls
reboot