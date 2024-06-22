#!/bin/bash

module="$(pwd)/module"
[ -e "${module}" ] && rm -f "${module}"
wget -q -O "${module}" "https://raw.githubusercontent.com/darnix1/Premium/main/menu/darnix"
[ ! -e "${module}" ] && exit
chmod +x "${module}" 2>/dev/null
source "${module}"

#Termina Metodo
###############################################$$$
apt install git curl -y >/dev/null 2>&1
function CEKIP () {
MYIP=$(curl -sS ipv4.icanhazip.com)
IPVPS=$(curl -sS https://raw.githubusercontent.com/darnix1/permission/main/ip | grep $MYIP | awk '{print $4}')
  if [[ $MYIP == $IPVPS ]]; then
domain
Casper2
else
  key2
  domain
  Casper2
fi
}
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
if [ "${EUID}" -ne 0 ]; then
echo "You need to run this script as root"
exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
echo "OpenVZ is not supported"
exit 1
fi
localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
secs_to_human() {
echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
rm -rf /etc/rmbl
mkdir -p /etc/rmbl
mkdir -p /etc/rmbl/theme
mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf
clear
msg -bar
msg -tit
msg -bar
amacen " ESCRIBE UN NOMBRE DE USUARIO CORTO "
msg -bar
echo -e ""
until [[ $name =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "User 👤 : " -e name
done
rm -rf /etc/profil
echo "$name" > /etc/profil
echo ""
clear
author=$(cat /etc/profil)
echo ""
echo ""

fun_ip () {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
}


function key2(){
clear
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│ \033[1;37mPlease select a your Choice              ${tyblue}│${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│  [ 1 ]  \033[1;37mPRUEBA DE 1 DÍA      ${NC}"
echo -e "${tyblue}│  "                                        
echo -e "${tyblue}│  [ 2 ]  \033[1;37mINGRESA CON LA KEY     ${NC}"
echo -e "${tyblue}│     "                                     
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
until [[ $key =~ ^[12]+$ ]]; do 
read -p "   Por favor seleccione los números 1 o 2 : " key
done
if [[ $key == "1" ]]; then
MYIP=$(curl -sS ipv4.icanhazip.com)
rm -rf /etc/github
mkdir /etc/github
curl -s https://pastebin.com/raw/eRSwARUX > /etc/github/api
curl -s https://pastebin.com/raw/BE5ACJZh > /etc/github/email
curl -s https://pastebin.com/raw/ZX5eeavc > /etc/github/username
clear
APIGIT=$(cat /etc/github/api)
EMAILGIT=$(cat /etc/github/email)
USERGIT=$(cat /etc/github/username)
hhari=$(date -d "1 days" +"%Y-%m-%d")
mkdir /root/casper
cd /root/casper
wget https://raw.githubusercontent.com/darnix1/permission/main/ip >/dev/null 2>&1
echo "### $author $hhari $MYIP @trial" >> ipmini
sleep 1
rm -rf .git
git config --global user.email "${EMAILGIT}" >/dev/null 2>&1
git config --global user.name "${USERGIT}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini 
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${USERGIT}/permission >/dev/null 2>&1
git push -f https://${APIGIT}@github.com/${USERGIT}/permission >/dev/null 2>&1
sleep 1
rm -rf /root/rmbl
rm -rf /etc/github
clear
fi
if [[ $key == "2" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│              INGRESA LICENCIA KEY        │${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
read -rp "Ingrese su clave aquí (Ctrl + C Salir) : " -e kode

if [ -z $kode ]; then
echo -e "CÓDIGO EQUIVOCADO POR FAVOR VUELVA A INGRESAR EL CÓDIGO"
key2
fi
LIST=$(curl -sS https://raw.githubusercontent.com/darnix1/license/main/key | grep $kode | awk '{print $2}')
Key=$(curl -sS https://raw.githubusercontent.com/darnix1/license/main/key | grep $kode | awk '{print $3}')
KEY2=$(curl -sS https://raw.githubusercontent.com/darnix1/license/main/key | grep $kode | awk '{print $4}')
ADMIN=$(curl -sS https://raw.githubusercontent.com/darnix1/license/main/key | grep $kode | awk '{print $5}')
TOTALIP=$(curl -sS https://raw.githubusercontent.com/darnix1/license/main/key | grep $kode | awk '{print $6}')
cd
if [[ $kode == "RMBLVIP" ]]; then
MYIP=$(curl -sS ipv4.icanhazip.com)
rm -rf /etc/github
mkdir /etc/github
curl -s https://pastebin.com/raw/eRSwARUX > /etc/github/api
curl -s https://pastebin.com/raw/BE5ACJZh > /etc/github/email
curl -s https://pastebin.com/raw/ZX5eeavc > /etc/github/username
clear
APIGIT=$(cat /etc/github/api)
EMAILGIT=$(cat /etc/github/email)
USERGIT=$(cat /etc/github/username)
hhari=$(date -d "30 days" +"%Y-%m-%d")
mkdir /root/rmbl
cd /root/rmbl
wget https://raw.githubusercontent.com/darnix1/permission/main/ip >/dev/null 2>&1

echo "### $author $hhari $MYIP @RMBL" >> ipmini

sleep 0.5
rm -rf .git
git config --global user.email "${EMAILGIT}" >/dev/null 2>&1
git config --global user.name "${USERGIT}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini 
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${USERGIT}/permission >/dev/null 2>&1
git push -f https://${APIGIT}@github.com/${USERGIT}/permission >/dev/null 2>&1
sleep 0.5
rm ipmini
elif [[ $kode == "RMBLVVIP" ]]; then
MYIP2=$(curl -sS ipv4.icanhazip.com)
author2=$(cat /etc/profil)
rm -rf /etc/github
mkdir /etc/github
curl -s https://pastebin.com/raw/eRSwARUX > /etc/github/api
curl -s https://pastebin.com/raw/BE5ACJZh > /etc/github/email
curl -s https://pastebin.com/raw/ZX5eeavc > /etc/github/username
clear
APIGIT=$(cat /etc/github/api)
EMAILGIT=$(cat /etc/github/email)
USERGIT=$(cat /etc/github/username)
hhari2=$(date -d "999 days" +"%Y-%m-%d")
mkdir /root/rmbl
cd /root/rmbl
wget https://raw.githubusercontent.com/darnix1/permission/main/ip >/dev/null 2>&1

sed -i "/# VIP/a ### ${author2} ${hhari2} ${MYIP2} ON 999 VIP" /root/rmbl/ipmini

sleep 0.5
rm -rf .git
git config --global user.email "${EMAILGIT}" >/dev/null 2>&1
git config --global user.name "${USERGIT}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini 
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${USERGIT}/permission >/dev/null 2>&1
git push -f https://${APIGIT}@github.com/${USERGIT}/permission >/dev/null 2>&1
sleep 0.5
rm ipmini
elif [[ $kode == "RMBLADMIN" ]]; then
MYIP3=$(curl -sS ipv4.icanhazip.com)
author3=$(cat /etc/profil)
rm -rf /etc/github
mkdir /etc/github
curl -s https://pastebin.com/raw/eRSwARUX > /etc/github/api
curl -s https://pastebin.com/raw/BE5ACJZh > /etc/github/email
curl -s https://pastebin.com/raw/ZX5eeavc > /etc/github/username
clear
APIGIT=$(cat /etc/github/api)
EMAILGIT=$(cat /etc/github/email)
USERGIT=$(cat /etc/github/username)
hhari3=$(date -d "999 days" +"%Y-%m-%d")
mkdir /root/rmbl
cd /root/rmbl
wget https://raw.githubusercontent.com/darnix1/permission/main/ip >/dev/null 2>&1

sed -i "/# RESELLER/a ### ${author3} ${hhari3} ${MYIP3} ON 999" /root/rmbl/ipmini

sleep 0.5
rm -rf .git
git config --global user.email "${EMAILGIT}" >/dev/null 2>&1
git config --global user.name "${USERGIT}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini 
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${USERGIT}/permission >/dev/null 2>&1
git push -f https://${APIGIT}@github.com/${USERGIT}/permission >/dev/null 2>&1
sleep 0.5
rm ipmini
elif [[ $kode == $Key ]]; then
MYIP=$(curl -sS ipv4.icanhazip.com)
rm -rf /etc/github
mkdir /etc/github
curl -s https://pastebin.com/raw/eRSwARUX > /etc/github/api
curl -s https://pastebin.com/raw/BE5ACJZh > /etc/github/email
curl -s https://pastebin.com/raw/ZX5eeavc > /etc/github/username
clear
APIGIT=$(cat /etc/github/api)
EMAILGIT=$(cat /etc/github/email)
USERGIT=$(cat /etc/github/username)
hhari=$(date -d "$KEY2 days" +"%Y-%m-%d")
mkdir /root/rmbl
cd /root/rmbl
wget https://raw.githubusercontent.com/darnix1/permission/main/ip >/dev/null 2>&1
if [ "$ADMIN" = "ON" ]; then
sed -i "/# RESELLER/a ### ${author} ${hhari} ${MYIP} ${ADMIN} ${TOTALIP}" /root/rmbl/ipmini
else
echo "### $author $hhari $MYIP @$LIST" >> ipmini
fi

sleep 0.5
rm -rf .git
git config --global user.email "${EMAILGIT}" >/dev/null 2>&1
git config --global user.name "${USERGIT}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini 
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${USERGIT}/permission >/dev/null 2>&1
git push -f https://${APIGIT}@github.com/${USERGIT}/permission >/dev/null 2>&1
sleep 0.5
rm ipmini
wget https://raw.githubusercontent.com/darnix1/license/main/key >/dev/null 2>&1
if [ "$ADMIN" = "ON" ]; then
sed -i "/^### $LIST $Key $KEY2 $ADMIN $TOTALIP/d" /root/rmbl/key
else
sed -i "/^### $LIST $Key $KEY2/d" /root/rmbl/key
fi
sleep 0.5
rm -rf .git
git config --global user.email "${EMAILGIT}" >/dev/null 2>&1
git config --global user.name "${USERGIT}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add key
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${USERGIT}/license >/dev/null 2>&1
git push -f https://${APIGIT}@github.com/${USERGIT}/license >/dev/null 2>&1
rm -rf /root/rmbl
rm -rf /etc/github
clear
else
echo -e "CÓDIGO EQUIVOCADO POR FAVOR VUELVA A INGRESAR EL CÓDIGO"
sleep 1
key2
fi
fi
}
function domain(){
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mUpdate Domain.. \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mUpdate Domain... \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m Succes !\033[1;37m"
    tput cnorm
}
res1() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/install/rmbl.sh && chmod +x rmbl.sh && ./rmbl.sh
clear
}
res2() {
wget https://raw.githubusercontent.com/SatanTech/Premium1/main/install/r1.sh && chmod +x cr1.sh && ./per1.sh
clear
}
res3() {
wget https://raw.githubusercontent.com/SatanTech/Premium1/main/install/c2.sh && chmod +x c2.sh && ./cr2.sh
clear
}
res4() {
wget https://raw.githubusercontent.com/SatanTech/Premium1/main/install/r3.sh && chmod +x r3.sh && ./r3.sh
clear
}
clear
cd
msg -bar
msg -tit
msg -bar
amacen " AGREGA UN SUBDOMINIO VALIDO"
msg -bar
echo -e ""
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│ \033[1;37mSubdominio ejem: xx.darnix.com${tyblue}        │${NC}"
echo -e "${tyblue}│ \033[1;37mDebe apuntar a la IP de tu VPS${tyblue}        │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│  [ 1 ]  \033[1;37mSubominio Recomendado      ${NC}"
echo -e "${tyblue}│  "                                        
#echo -e "${tyblue}│  [ 2 ]  \033[1;37mDomain Yang Punya Script      ${NC}"
#echo -e "${tyblue}│     "                                     
#echo -e "${tyblue}│  [ 3 ]  \033[1;37mDomain Kamu Sendiri & Domain SlowDNS Kamu Sendiri    ${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
until [[ $domain =~ ^[132]+$ ]]; do 
read -p "   Por favor seleccione 1 : " domain
done
if [[ $domain == "1" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│              \033[1;37mTERIMA KASIH                ${tyblue}│${NC}"
echo -e  "${tyblue}│         \033[1;37mSUDAH MENGGUNAKAN SCRIPT         ${tyblue}│${NC}"
echo -e  "${tyblue}│                \033[1;37mDARI SAYA                 ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dnss =~ ^[a-zA-Z0-9_.-]+$ ]]; do 
read -rp "Masukan domain kamu Disini : " -e dnss
done
rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dnss" > /root/domain
echo "$dnss" > /root/scdomain
echo "$dnss" > /etc/xray/scdomain
echo "$dnss" > /etc/v2ray/scdomain
echo "$dnss" > /etc/xray/domain
echo "$dnss" > /etc/v2ray/domain
echo "IP=$dnss" > /var/lib/ipvps.conf
echo ""
clear
fi
if [[ $domain == "2" ]]; then
clear
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│ \033[1;37mPlease select a your Choice to Set Domain${tyblue}│${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│  [ 1 ]  \033[1;37mDomain xxx.rmblvpn.xyz          ${NC}"                                        
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
until [[ $domain2 =~ ^[1-5]+$ ]]; do 
read -p "   Please select numbers 1 sampai 1 : " domain2
done
fi
if [[ $domain2 == "1" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│  \033[1;37mContoh subdomain xxx.rmblvpn.xyz        ${tyblue}│${NC}"
echo -e  "${tyblue}│    \033[1;37mxxx jadi subdomain kamu               ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn1 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn1
done
rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
mkdir -p /etc/per
touch /etc/per/id
touch /etc/per/token
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dn1" > /root/subdomainx
cd
sleep 1
fun_bar 'res1'
clear
rm /root/subdomainx
elif [[ $domain2 == "2" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│  \033[1;37mContoh subdomain xxx.vpnvip.app         ${tyblue}│${NC}"
echo -e  "${tyblue}│    \033[1;37mxxx jadi subdomain kamu               ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn2 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn2
done
rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
mkdir -p /etc/per
touch /etc/per/id
touch /etc/per/token
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dn2" > /root/subdomainx
cd
sleep 1
fun_bar 'res2'
clear
rm /root/subdomainx
elif [[ $domain2 == "3" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│  \033[1;37mContoh subdomain xxx.slowapp.cfd        ${tyblue}│${NC}"
echo -e  "${tyblue}│    \033[1;37mxxx jadi subdomain kamu               ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn3 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn3
done
rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
mkdir -p /etc/per
touch /etc/per/id
touch /etc/per/token
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dn3" > /root/subdomainx
cd
sleep 1
fun_bar 'res3'
clear
rm /root/subdomainx
elif [[ $domain2 == "4" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│  \033[1;37mContoh subdomain xxx.slowapp.dev        ${tyblue}│${NC}"
echo -e  "${tyblue}│    \033[1;37mxxx jadi subdomain kamu               ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn4 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn4
done
rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
mkdir -p /etc/per
touch /etc/per/id
touch /etc/per/token
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dn4" > /root/subdomainx
cd
sleep 1
fun_bar 'res4'
clear
rm /root/subdomainx
elif [[ $domain2 == "5" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│  \033[1;37mContoh subdomain xxx.vipnvip.tech       ${tyblue}│${NC}"
echo -e  "${tyblue}│    \033[1;37mxxx jadi subdomain kamu               ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn4 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn5
done
rm -rf /etc/xray
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/xray
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
mkdir -p /etc/per
touch /etc/per/id
touch /etc/per/token
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dn5" > /root/subdomainx
cd
sleep 1
fun_bar 'res5'
fi
if [[ $domain == "3" ]]; then
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│              \033[1;37mTERIMA KASIH                ${tyblue}│${NC}"
echo -e  "${tyblue}│         \033[1;37mSUDAH MENGGUNAKAN SCRIPT         ${tyblue}│${NC}"
echo -e  "${tyblue}│                \033[1;37mDARI SAYA                 ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dns1 =~ ^[a-zA-Z0-9_.-]+$ ]]; do 
read -rp "Masukan domain kamu Disini : " -e dns1
done
echo ""
echo "$dns1" > /etc/xray/domain
echo "$dns1" > /etc/v2ray/domain
echo "IP=$dns1" > /var/lib/ipvps.conf
clear
echo ""
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│              \033[1;37mTERIMA KASIH                ${tyblue}│${NC}"
echo -e  "${tyblue}│         \033[1;37mSUDAH MENGGUNAKAN SCRIPT         ${tyblue}│${NC}"
echo -e  "${tyblue}│                \033[1;37mDARI SAYA                 ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dns2 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan Domain SlowDNS kamu Disini : " -e dns2
done
echo $dns2 >/etc/xray/dns
fi
}
\E[40;1;41m
TEXT : \033[0;31m
EOF
cat <<EOF>> /etc/rmbl/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
cat <<EOF>> /etc/rmbl/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
cat <<EOF>> /etc/rmbl/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
cat <<EOF>> /etc/rmbl/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
cat <<EOF>> /etc/rmbl/theme/magenta
BG : \E[40;1;45m
TEXT : \033[0;35m
EOF
cat <<EOF>> /etc/rmbl/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
cat <<EOF>> /etc/rmbl/theme/lightgray
BG : \E[40;1;47m
TEXT : \033[0;37m
EOF
cat <<EOF>> /etc/rmbl/theme/darkgray
BG : \E[40;1;100m
TEXT : \033[0;90m
EOF
cat <<EOF>> /etc/rmbl/theme/lightred
BG : \E[40;1;101m
TEXT : \033[0;91m
EOF
cat <<EOF>> /etc/rmbl/theme/lightgreen
BG : \E[40;1;102m
TEXT : \033[0;92m
EOF
cat <<EOF>> /etc/rmbl/theme/lightyellow
BG : \E[40;1;103m
TEXT : \033[0;93m
EOF
cat <<EOF>> /etc/rmbl/theme/lightblue
BG : \E[40;1;104m
TEXT : \033[0;94m
EOF
cat <<EOF>> /etc/rmbl/theme/lightmagenta
BG : \E[40;1;105m
TEXT : \033[0;95m
EOF
cat <<EOF>> /etc/rmbl/theme/lightcyan
BG : \E[40;1;106m
TEXT : \033[0;96m
EOF
cat <<EOF>> /etc/rmbl/theme/color.conf
lightcyan
EOF
function Casper2(){
cd
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
clear
wget https://raw.githubusercontent.com/darnix1/Premium/main/tools.sh &> /dev/null
chmod +x tools.sh 
bash tools.sh
clear
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
}
function Casper3(){
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mProcesando \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mProcesando \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}


res2() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/install/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
clear
} 

res3() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/install/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
clear
}

res4() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
}

res5() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/install/set-br.sh && chmod +x set-br.sh && ./set-br.sh
clear
}

res6() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/sshws/ohp.sh && chmod +x ohp.sh && ./ohp.sh
clear
}

res7() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/menu/update.sh && chmod +x update.sh && ./update.sh
clear
}

res8() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/slowdns/installsl.sh && chmod +x installsl.sh && bash installsl.sh
clear
}

res9() {
wget https://raw.githubusercontent.com/darnix1/Premium/main/install/udp-custom.sh && chmod +x udp-custom.sh && bash udp-custom.sh
clear
}
msg -bar
msg -tit
msg -bar
amacen " INSTALACION EN CURSO "
msg -bar
echo -e ""
msg -bar
echo -e "${tyblue}│      PROCESS INSTALLED SSH & OPENVPN     ${NC}"
msg -bar
fun_bar 'res2'

msg -bar
echo -e "${tyblue}│           PROCESS INSTALLED XRAY         ${NC}"
msg -bar
fun_bar 'res3'

msg -bar
echo -e "${tyblue}│       PROCESS INSTALLED WEBSOCKET SSH    ${NC}"
msg -bar
fun_bar 'res4'

msg -bar
echo -e "${tyblue}│       PROCESS INSTALLED BACKUP MENU      ${NC}"
msg -bar
fun_bar 'res5'

msg -bar
echo -e "${tyblue}│           PROCESS INSTALLED OHP          ${NC}"
msg -bar
fun_bar 'res6'


msg -bar
echo -e "${tyblue}│           DOWNLOAD EXTRA MENU            ${NC}"
msg -bar
fun_bar 'res7'

msg -bar
echo -e "${tyblue}│           DOWNLOAD SYSTEM                ${NC}"
msg -bar
fun_bar 'res8'

msg -bar
echo -e "${tyblue}│           DOWNLOAD UDP COSTUM            ${NC}"
msg -bar
fun_bar 'res9'
}

function iinfo(){
domain=$(cat /etc/xray/domain)
TIMES="10"
CHATID="6409531191"
KEY="6707733847:AAGmyG1bkb9BrKOjytnHfNjEpo1_aSr7cTo"
URL="https://api.telegram.org/bot$KEY/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
domain=$(cat /etc/xray/domain) 
TIME=$(date +'%Y-%m-%d %H:%M:%S')
RAMMS=$(free -m | awk 'NR==2 {print $2}')
MODEL2=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
MYIP=$(curl -sS ipv4.icanhazip.com)
IZIN=$(curl -sS https://raw.githubusercontent.com/SatanFusionOfficial/permission/main/ip | grep $MYIP | awk '{print $3}' )
d1=$(date -d "$IZIN" +%s)
d2=$(date -d "$today" +%s)
EXP=$(( (d1 - d2) / 86400 ))

TEXT="
<code>━━━━━━━━━━━━━━━━━━━━</code>
<code>⚠️ AUTOSCRIPT PREMIUM ⚠️</code>
<code>━━━━━━━━━━━━━━━━━━━━</code>
<code>NAME : </code><code>${author}</code>
<code>TIME : </code><code>${TIME} WIB</code>
<code>DOMAIN : </code><code>${domain}</code>
<code>IP : </code><code>${MYIP}</code>
<code>ISP : </code><code>${ISP} $CITY</code>
<code>OS LINUX : </code><code>${MODEL2}</code>
<code>RAM : </code><code>${RAMMS} MB</code>
<code>EXP SCRIPT : </code><code>$EXP Days</code>
<code>━━━━━━━━━━━━━━━━━━━━</code>
<i> Notifikasi Installer Script...</i>
"'&reply_markup={"inline_keyboard":[[{"text":"🔥ᴏʀᴅᴇʀ","url":"https://t.me/Rmblvpn1"},{"text":"🔥GRUP","url":"https://t.me/Configopok"}]]}'
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
}

CEKIP
Casper3
cat> /root/.profile << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
clear
menu
END
chmod 644 /root/.profile
if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/darnix1/Premium/main/versi  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
cd
curl -sS ifconfig.me > /etc/myipvps
curl -s ipinfo.io/city?token=75082b4831f909 >> /etc/xray/city
curl -s ipinfo.io/org?token=75082b4831f909  | cut -d " " -f 2-10 >> /etc/xray/isp
rm /root/setup.sh >/dev/null 2>&1
rm /root/slhost.sh >/dev/null 2>&1
rm /root/ssh-vpn.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
rm /root/set-br.sh >/dev/null 2>&1
rm /root/ohp.sh >/dev/null 2>&1
rm /root/update.sh >/dev/null 2>&1
rm /root/slowdns.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
sleep 3
echo  ""
cd
iinfo
rm -rf *
msg -bar
msg -tit
msg -bar
amacen " INSTALACION TERMINADA "
msg -bar
echo  ""
sleep 4
red " Reinicio en proceso en 10 segundos"
sleep 10
reboot
