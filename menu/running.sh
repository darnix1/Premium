#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m"
export COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
ipsaya=$(wget -qO- ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')

MYIP=$(curl -sS ipv4.icanhazip.com)

export RED='\033[0;31m'
export GREEN='\033[0;32m'
clear
source /etc/os-release
Versi_OS=$VERSION
ver=$VERSION_ID
Tipe=$NAME
URL_SUPPORT=$HOME_URL
basedong=$ID
REGION=$( curl -s ipinfo.io/region )
CITY=$( curl -s ipinfo.io/city )
oovpn=$(systemctl status openvpn | grep Active | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1)
tls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nontls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_tls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_nontls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
shadowsocks=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trojan_server=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
stunnel_service=$(/etc/init.d/stunnel4 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wstls=$(systemctl status ws-stunnel.service | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wsovpn=$(systemctl status ws-ovpn | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
osslh=$(systemctl status sslh | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
udp=$(systemctl status udp-custom | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
sls=$(systemctl status server | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
slc=$(systemctl status client | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
clear
if [[ $oovpn == "active" ]]; then
status_openvpn=" ${GREEN}Running ${NC}( No Error )"
else
status_openvpn="${RED}  Not Running ${NC}  ( Error )"
fi
if [[ $ssh_service == "running" ]]; then
status_ssh=" ${GREEN}Running ${NC}( No Error )"
else
status_ssh="${RED}  Not Running ${NC}  ( Error )"
fi
if [[ $squid_service == "running" ]]; then
status_squid=" ${GREEN}Running ${NC}( No Error )"
else
status_squid="${RED}  Not Running ${NC}  ( Error )"
fi
if [[ $vnstat_service == "running" ]]; then
status_vnstat=" ${GREEN}Running ${NC}( No Error )"
else
status_vnstat="${RED}  Not Running ${NC}  ( Error )"
fi
if [[ $cron_service == "running" ]]; then
status_cron=" ${GREEN}Running ${NC}( No Error )"
else
status_cron="${RED}  Not Running ${NC}  ( Error )"
fi
if [[ $fail2ban_service == "running" ]]; then
status_fail2ban=" ${GREEN}Running ${NC}( No Error )"
else
status_fail2ban="${RED}  Not Running ${NC}  ( Error )"
fi
if [[ $tls_v2ray_status == "running" ]]; then
status_tls_v2ray=" ${GREEN}Running${NC} ( No Error )"
else
status_tls_v2ray="${RED}  Not Running${NC}   ( Error )"
fi
if [[ $nontls_v2ray_status == "running" ]]; then
status_nontls_v2ray=" ${GREEN}Running ${NC}( No Error )${NC}"
else
status_nontls_v2ray="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $vless_tls_v2ray_status == "running" ]]; then
status_tls_vless=" ${GREEN}Running${NC} ( No Error )"
else
status_tls_vless="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $vless_nontls_v2ray_status == "running" ]]; then
status_nontls_vless=" ${GREEN}Running${NC} ( No Error )"
else
status_nontls_vless="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $trojan_server == "running" ]]; then
status_virus_trojan=" ${GREEN}Running ${NC}( No Error )${NC}"
else
status_virus_trojan="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $dropbear_status == "running" ]]; then
status_beruangjatuh=" ${GREEN}Running${NC} ( No Error )${NC}"
else
status_beruangjatuh="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $stunnel_service == "running" ]]; then
status_stunnel=" ${GREEN}Running ${NC}( No Error )"
else
status_stunnel="${RED}  Not Running ${NC}  ( Error )}"
fi
if [[ $wstls == "running" ]]; then
swstls=" ${GREEN}Running ${NC}( No Error )${NC}"
else
swstls="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $osslh == "running" ]]; then
sosslh=" ${GREEN}Running ${NC}( No Error )${NC}"
else
sosslh="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $udp == "running" ]]; then
udp=" ${GREEN}Running ${NC}( No Error )${NC}"
else
udp="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $sls == "running" ]]; then
sls=" ${GREEN}Running ${NC}( No Error )${NC}"
else
sls="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $slc == "running" ]]; then
slc=" ${GREEN}Running ${NC}( No Error )${NC}"
else
slc="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
if [[ $shadowsocks == "running" ]]; then
status_shadowsocks=" ${GREEN}Running ${NC}( No Error )${NC}"
else
status_shadowsocks="${RED}  Not Running ${NC}  ( Error )${NC}"
fi
total_ram=`grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))
kernelku=$(uname -r)
DATE=$(date +'%Y-%m-%d')
datediff() {
d1=$(date -d "$1" +%s)
d2=$(date -d "$2" +%s)
echo -e "$COLOR1 $NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""
today=`date -d "0 days" +"%Y-%m-%d"`
Exp2=$(curl -sS https://raw.githubusercontent.com/SatanFusionOfficial/permission/main/ip | grep $MYIP | awk '{print $3}')
d1=$(date -d "$Exp2" +%s)
d2=$(date -d "$today" +%s)
certificate=$(( (d1 - d2) / 86400 ))
Name2=$(curl -sS https://raw.githubusercontent.com/SatanFusionOfficial/permission/main/ip | grep $MYIP | awk '{print $2}')
Domen="$(cat /etc/xray/domain)"
function restartservice(){
clear
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
echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
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
echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
done
echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
res1() {
systemctl restart nginx
systemctl restart xray
systemctl restart daemon
systemctl restart udp-custom
systemctl restart client
systemctl restart server
systemctl restart ws-dropbear
systemctl restart ws-stunnel
systemctl restart openvpn
systemctl restart cron
systemctl restart netfilter-persistent
systemctl restart squid
systemctl restart badvpn1
systemctl restart badvpn2
systemctl restart badvpn3
systemctl restart kyt
}
clear
echo -e "$COLOR1 ┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}RESTART SERVICE VPS             ${NC} $COLOR1 $NC"
echo -e "$COLOR1 └──────────────────────────────────────────┘${NC}"
echo -e ""
echo -e "  \033[1;91m Restart All Service... \033[1;37m"
fun_bar 'res1'
echo -e ""
read -n 1 -s -r -p "Press [ Enter ] to back on menu"
menu
}
function menuservice(){
clear
echo -e ""
echo -e ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice              $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mRestart ALL Service       ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 2 ]  \033[1;37mStop Service      ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 3 ]  \033[1;37mStart Service      ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  "
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 0 ]  \033[1;37mBack To menu ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $serr =~ ^[0-3]+$ ]]; do
read -p "   Please select numbers 1 - 3 : " serr
done
if [[ $serr == "0" ]]; then
menu
elif [[ $serr == "1" ]]; then
restartservice
elif [[ $serr == "2" ]]; then
clear
echo -e ""
echo -e ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice              $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mSTOP SERVICE OVPN      ${NC}"
echo -e "$COLOR1│  [ 2 ]  \033[1;37mSTOP SERVICE SLOWDNS     ${NC}"
echo -e "$COLOR1│  [ 3 ]  \033[1;37mSTOP SERVICE UDP COSTUM     ${NC}"
echo -e "$COLOR1│  [ 4 ]  \033[1;37mSTOP SERVICE SSH ${NC}"
echo -e "$COLOR1│  [ 5 ]  \033[1;37mSTOP SERVICE XRAY ${NC}"
echo -e "$COLOR1│  [ 6 ]  \033[1;37mSTOP SERVICE NGINX ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 0 ]  \033[1;37mBack To menu ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $vice =~ ^[0-6]+$ ]]; do
read -p "   Please select numbers 1 - 6 : " vice
done
if [[ $vice == "0" ]]; then
menu
elif [[ $vice == "1" ]]; then
systemctl stop openvpn
systemctl stop ws-ovpn
systemctl disable openvpn
systemctl disable ws-ovpn
read -n 1 -s -r -p "  Succes Stop Service. Press any key to Back Menu"
menu
elif [[ $vice == "2" ]]; then
systemctl stop client
systemctl stop server
systemctl disable client
systemctl disable server
read -n 1 -s -r -p "  Succes Stop Service. Press any key to Back Menu"
menu
elif [[ $vice == "3" ]]; then
systemctl stop udp-custom
systemctl disable udp-custom
read -n 1 -s -r -p "  Succes Stop Service. Press any key to Back Menu"
menu
elif [[ $vice == "4" ]]; then
systemctl stop ws-stunnel
systemctl disable ws-stunnel
read -n 1 -s -r -p "  Succes Stop Service. Press any key to Back Menu"
menu
elif [[ $vice == "5" ]]; then
systemctl stop xray
systemctl disable xray
read -n 1 -s -r -p "  Succes Stop Service. Press any key to Back Menu"
menu
elif [[ $vice == "6" ]]; then
systemctl stop nginx
systemctl disable nginx
read -n 1 -s -r -p "  Succes Stop Service. Press any key to Back Menu"
menu
fi
elif [[ $serr == "3" ]]; then
clear
echo -e ""
echo -e ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice              $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mSTART SERVICE OVPN      ${NC}"
echo -e "$COLOR1│  [ 2 ]  \033[1;37mSTART SERVICE SLOWDNS     ${NC}"
echo -e "$COLOR1│  [ 3 ]  \033[1;37mSTART SERVICE UDP COSTUM     ${NC}"
echo -e "$COLOR1│  [ 4 ]  \033[1;37mSTART SERVICE SSH ${NC}"
echo -e "$COLOR1│  [ 5 ]  \033[1;37mSTART SERVICE XRAY ${NC}"
echo -e "$COLOR1│  [ 6 ]  \033[1;37mSTART SERVICE NGINX ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 0 ]  \033[1;37mBack To menu ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $vice =~ ^[0-6]+$ ]]; do
read -p "   Please select numbers 1 - 6 : " vice
done
if [[ $vice == "0" ]]; then
menu
elif [[ $vice == "1" ]]; then
systemctl enable openvpn
systemctl enable ws-ovpn
systemctl restart openvpn
systemctl restart ws-ovpn
read -n 1 -s -r -p "  Succes Start Service. Press any key to Back Menu"
menu
elif [[ $vice == "2" ]]; then
systemctl enable client
systemctl enable server
systemctl restart client
systemctl restart server
read -n 1 -s -r -p "  Succes Start Service. Press any key to Back Menu"
menu
elif [[ $vice == "3" ]]; then
systemctl enable udp-custom
systemctl restart udp-custom
read -n 1 -s -r -p "  Succes Start Service. Press any key to Back Menu"
menu
elif [[ $vice == "4" ]]; then
systemctl enable ws-stunnel
systemctl restart ws-stunnel
read -n 1 -s -r -p "  Succes Start Service. Press any key to Back Menu"
menu
elif [[ $vice == "5" ]]; then
systemctl enable xray
systemctl restart xray
read -n 1 -s -r -p "  Succes Start Service. Press any key to Back Menu"
menu
elif [[ $vice == "6" ]]; then
systemctl stop nginx
systemctl disable nginx
read -n 1 -s -r -p "  Succes Start Service. Press any key to Back Menu"
menu
fi
fi
menu
}
echo -e ""
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}⇱ SYSTEM INFORMATION ⇲${NC}                       $COLOR1 $NC"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 $NC  ${WH} Hostname    ${COLOR1}: ${WH}$HOSTNAME$NC"
echo -e "$COLOR1 $NC  ${WH} OS Name     ${COLOR1}: ${WH}$Tipe$NC"
echo -e "$COLOR1 $NC  ${WH} Total RAM   ${COLOR1}: ${WH}${totalram}MB$NC"
echo -e "$COLOR1 $NC  ${WH} Public IP   ${COLOR1}: ${WH}$MYIP$NC"
echo -e "$COLOR1 $NC  ${WH} Domain      ${COLOR1}: ${WH}$Domen$NC"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}⇱ SUBSCRIPTION INFORMATION ⇲${NC}                $COLOR1 $NC"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 $NC  ${WH} Client Name ${COLOR1}: ${WH}$Name2${NC}"
echo -e "$COLOR1 $NC  ${WH} License     ${COLOR1}: ${WH}$certificate days${NC}"
echo -e "$COLOR1 $NC  ${WH} Version     ${COLOR1}: ${WH}VIP Version${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}⇱ SERVICE INFORMATION ⇲${NC}                 $COLOR1 $NC"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 $NC  ${WH} SSH / TUN               ${COLOR1}: ${WH}$status_ssh${NC}"
echo -e "$COLOR1 $NC  ${WH} OpenVPN                 ${COLOR1}: ${WH}$status_openvpn${NC}"
echo -e "$COLOR1 $NC  ${WH} Dropbear                ${COLOR1}: ${WH}$status_beruangjatuh${NC}"
echo -e "$COLOR1 $NC  ${WH} Stunnel4                ${COLOR1}: ${WH}$status_stunnel${NC}"
echo -e "$COLOR1 $NC  ${WH} Crons                   ${COLOR1}: ${WH}$status_cron${NC}"
echo -e "$COLOR1 $NC  ${WH} Vnstat                  ${COLOR1}: ${WH}$status_vnstat${NC}"
echo -e "$COLOR1 $NC  ${WH} XRAYS Vmess TLS         ${COLOR1}: ${WH}$status_tls_v2ray${NC}"
echo -e "$COLOR1 $NC  ${WH} XRAYS Vmess None TLS    ${COLOR1}: ${WH}$status_nontls_v2ray${NC}"
echo -e "$COLOR1 $NC  ${WH} XRAYS Vless TLS         ${COLOR1}: ${WH}$status_tls_vless${NC}"
echo -e "$COLOR1 $NC  ${WH} XRAYS Vless None TLS    ${COLOR1}: ${WH}$status_nontls_vless${NC}"
echo -e "$COLOR1 $NC  ${WH} XRAYS Trojan            ${COLOR1}: ${WH}$status_virus_trojan${NC}"
echo -e "$COLOR1 $NC  ${WH} Shadowsocks             ${COLOR1}: ${WH}$status_shadowsocks${NC}"
echo -e "$COLOR1 $NC  ${WH} Websocket TLS           ${COLOR1}: ${WH}$swstls${NC}"
echo -e "$COLOR1 $NC  ${WH} Websocket None TLS      ${COLOR1}: ${WH}$swstls${NC}"
echo -e "$COLOR1 $NC  ${WH} Websocket None TLS      ${COLOR1}: ${WH}$swstls${NC}"
echo -e "$COLOR1 $NC  ${WH} SSH UDP COSTUM          ${COLOR1}: ${WH}$udp${NC}"
#echo -e "$COLOR1 $NC  ${WH} SlowDNS CLIENT          ${COLOR1}: ${WH}$slc${NC}"
#echo -e "$COLOR1 $NC  ${WH} SlowDNS SERVER          ${COLOR1}: ${WH}$sls${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}🔥 SCRIPT 🔥 ${NC}                    $COLOR1 $NC"
echo -e "$COLOR1 ${NC}               ${WH}🔥 RMBL VPN🔥 ${NC}                   $COLOR1 $NC"
echo -e "$COLOR1└───────────────────────────────────────────────────┘${NC}"
read -n 1 -s -r -p "Press any key to Enter Menu Service"
menuservice
