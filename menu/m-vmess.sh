#!/bin/bash


case $newlang in
  en_US)  a_enter='Press enter to continue'
          a_back='RETURN'
          a_selection_fun='Select an Option:';;
esac

# varibles
export _hora=$(printf '%(%H:%M:%S)T') 
export _fecha=$(printf '%(%D)T')

export numero='^[0-9]+$'
export texto='^[A-Za-z]+$'
export txt_num='^[A-Za-z0-9]+$'


#Letras con contorno 
dnxroj() { echo -e "\e[1;37;41m${*}\e[0m";}
dnxver() { echo -e "\e[1;37;42m${*}\e[0m";}

#Letras de colores sin contorno 
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
amacen() { echo -e "\e[1;93m              ${*}"; } 


#Funciones menu abajo 
function sres {
    echo -e "    \e[97m\033[1;41m ENTER SIN RESPUESTA REGRESA A MENU ANTERIOR \033[0;97m"
}

msg() { ##-->> COLORES, TITULO, BARRAS
  if [[ ! -e $colors ]]; then
    COLOR[0]='\033[1;37m' #GRIS='\033[1;37m'
    COLOR[1]='\e[31m'     #ROJO='\e[31m'
    COLOR[2]='\e[32m'     #VERDE='\e[32m'
    COLOR[3]='\e[33m'     #AMARILLO='\e[33m'
    COLOR[4]='\e[34m'     #AZUL='\e[34m'
    COLOR[5]='\e[91m'     #ROJO-NEON='\e[91m'
    COLOR[6]='\033[1;97m' #BALNCO='\033[1;97m'

  else
    local COL=0
    for number in $(cat $colors); do
      case $number in
      1) COLOR[$COL]='\033[1;37m' ;;
      2) COLOR[$COL]='\e[31m' ;;
      3) COLOR[$COL]='\e[32m' ;;
      4) COLOR[$COL]='\e[33m' ;;
      5) COLOR[$COL]='\e[34m' ;;
      6) COLOR[$COL]='\e[35m' ;;
      7) COLOR[$COL]='\033[1;36m' ;;
      esac
      let COL++
    done
  fi
  NEGRITO='\e[1m'
  SINCOLOR='\e[0m'
  case $1 in
  -ne) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
  -nazu) cor="${COLOR[6]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -ama) cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
  -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SINCOLOR}" ;;
  -verm2) cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
  -azu) cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
  -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
  -bra) cor="${COLOR[0]}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
  -bar2)cor="\e[38;5;239m════════════════════════════════════════════════════" && echo -e "${cor}${SEMCOR}";;
  -bar)cor="\e[38;5;239m════════════════════════════════════════════════════" && echo -e "${cor}${SEMCOR}";;
  -tix) echo -e "\e[1;33m ❰❰❰ ░Ｄ░ ░Ａ░ ░Ｒ░ ░Ｎ░ ░Ｉ░ ░Ｘ░ ❱❱❱ 𝗩𝗲𝗿𝘀𝗶𝗼𝗻:  \e[0m"
 -tit) 
echo -e "\e[1;33m ❰❰❰ ░Ｄ░ ░Ａ░ ░Ｒ░ ░Ｎ░ ░Ｉ░ ░Ｘ░ ❱❱❱ 𝗩𝗲𝗿𝘀𝗶𝗼𝗻: $(cat /opt/.ver) \e[0m"
#test -f /opt/.ver && echo -e "\e[1;33m ❰❰❰ ░Ｄ░ ░Ａ░ ░Ｒ░ ░Ｎ░ ░Ｉ░ ░Ｘ░ ❱❱❱ 𝗩𝗲𝗿𝘀𝗶𝗼𝗻: $(cat /opt/.ver) \e[0m"
  esac
}
#Título

title(){
    clear
    msg -bar
    if [[ -z $2 ]]; then
      msg -tit
      print_center -ama "$1"
    else
      print_center "$1" "$2"
    fi
    msg -bar
 }
 
print_center(){
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi
  while read line; do
    unset space
    x=$(( ( 54 - ${#line}) / 2))
    for (( i = 0; i < $x; i++ )); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msgi -azu "$space"
    else
      msgi "$col" "$space"
    fi
  done <<< $(echo -e "$text")
}

enter(){
  msg -bar
  text="►► ${a_enter:-Presione enter para continuar} ◄◄"
  if [[ -z $1 ]]; then
    print_center -ama "$text"
  else
    print_center "$1" "$text"
  fi
  read
 }

# opcion, regresar volver/atras
back(){
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > " && msg -bra "\e[97m\033[1;41m${a_back:-VOLVER} \033[0;37m"
    msg -bar
 }
 
#MENU
 menu_func(){
  local options=${#@}
  local array
  for((num=1; num<=$options; num++)); do
    echo -ne "\033[1;33m[\033[32m$num\033[1;33m] \033[1;31m> \033[0m"
    array=(${!num})
    case ${array[0]} in
      "-vd") echo -e "\033[1;33m[\033[1;32m!\033[1;33m] \033[1;32m${array[@]:1}${SINCOLOR}";;
      "-vm") echo -e "\033[1;33m[\033[1;31m!\033[1;33m] \033[1;31m${array[@]:1}${SINCOLOR}";;
      "-fi") echo -e "\033[1;33m[\033[1;37m!\033[1;33m] \033[1;37m${array[@]:2} ${array[1]}${SINCOLOR}";; 
      -bar|-bar2|-bar3|-bar4)echo -e "\033[1;37m${array[@]:1}\n$(msg ${array[0]})";;
      *)echo -e "\033[1;37m${array[@]}";;
    esac
  done
 }

 #Seleccion de menu pequeño
in_opcion(){
  unset opcion
  if [[ -z $2 ]]; then
      msg -nazu " $1: " >&2
  else
      msg $1 " $2: " >&2
  fi
  read opcion
  echo "$opcion"
}

in_opcion_down(){
  dat=$1
  length=${#dat}
  cal=$(( 22 - $length / 2 ))
  line=''
  for (( i = 0; i < $cal; i++ )); do
    line+='╼'
  done
  echo -e " $(msg -verm3 "╭$line╼[")$(msg -azu "$dat")$(msg -verm3 "]")"
  echo -ne " $(msg -verm3 "╰╼")\033[37;1m> " && read opcion
}

#Seleccion
 
selection_fun() {
  local selection
  local options="$(seq 0 $1 | paste -sd "," -)"
  read -p $'\033[1;97m  └⊳ Seleccione una opción:\033[1;32m ' selection
  if [[ $options =~ (^|[^\d])$selection($|[^\d]) ]]; then
    echo $selection
  else
    echo "Selección no válida: $selection" >&2
    exit 1
  fi
}

selection_fun2(){
  local selection="null"
  local range
  if [[ -z $2 ]]; then
    opcion=$1
    col="-nazu"
  else
    opcion=$2
    col=$1
  fi
  for((i=0; i<=$opcion; i++)); do range[$i]="$i "; done
  while [[ ! $(echo ${range[*]}|grep -w "$selection") ]]; do
    msg "$col" " ${a_selection_fun:- └⊳ Seleccione una Opcion}: " >&2
    read selection
    tput cuu1 >&2 && tput dl1 >&2
  done
  echo $selection
}

#Elimina

del(){
  for (( i = 0; i < $1; i++ )); do
    tput cuu1 && tput dl1
  done
}

export -f msgi
export -f msg
export -f banner
export -f selection_fun
export -f menu_func
export -f print_center
export -f title
export -f back
export -f enter
export -f in_opcion
export -f in_opcion_down
export -f del


#Termina Metodo
###############################################$$$




biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ifconfig.me)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')

clear
cd
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
TIMES="10"
CHATID=$(cat /etc/per/id)
KEY=$(cat /etc/per/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domain=`cat /etc/xray/domain`
CHATID2=$(cat /etc/perlogin/id)
KEY2=$(cat /etc/perlogin/token)
URL2="https://api.telegram.org/bot$KEY2/sendMessage"
cd
if [ ! -e /etc/vmess/akun ]; then
mkdir -p /etc/vmess/akun
fi
function add-vmess(){
clear
until [[ $user =~ ^[a-zA-Z0-9_.-]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}             ${WH}• Add Vmess Account •               ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -rp "User: " -e user
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ ${NC} ${COLBG1}            ${WH}• Add Vmess Account •              ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│                                                 │"
echo -e "$COLOR1│${WH} Nama Duplikat Silahkan Buat Nama Lain.          $COLOR1│"
echo -e "$COLOR1│                                                 │"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
read -n 1 -s -r -p "Press any key to back"
add-vmess
fi
done
uuid=$(cat /proc/sys/kernel/random/uuid)
until [[ $masaaktif =~ ^[0-9]+$ ]]; do
read -p "Expired (hari): " masaaktif
done
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
until [[ $iplim =~ ^[0-9]+$ ]]; do
read -p "Limit User (IP) or 0 Unlimited: " iplim
done
until [[ $Quota =~ ^[0-9]+$ ]]; do
read -p "Limit User (GB) or 0 Unlimited: " Quota
done
if [ ! -e /etc/vmess ]; then
mkdir -p /etc/vmess
fi
if [ ${iplim} = '0' ]; then
iplim="9999"
fi
if [ ${Quota} = '0' ]; then
Quota="9999"
fi
c=$(echo "${Quota}" | sed 's/[^0-9]*//g')
d=$((${c} * 1024 * 1024 * 1024))
if [[ ${c} != "0" ]]; then
echo "${d}" >/etc/vmess/${user}
fi
echo "${iplim}" >/etc/vmess/${user}IP
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\#vmg '"$user $exp $uuid"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
asu=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
ask=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "none"
}
EOF`
grpc=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "grpc",
"path": "vmess-grpc",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
VMESS_WS=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
VMESS_NON_TLS=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "none"
}
EOF`
VMESS_GRPC=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "grpc",
"path": "/vmess-grpc",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
VMESS_OPOK=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "http://tsel.me/worryfree",
"type": "none",
"host": "tsel.me",
"tls": "none"
}
EOF`
cat > /home/vps/public_html/vmess-$user.txt <<-END
_______________________________________________________
Format Vmess WS (CDN)
_______________________________________________________
- name: vmess-$user-WS (CDN)
type: vmess
server: ${domain}
port: 443
uuid: ${uuid}
alterId: 0
cipher: auto
udp: true
tls: true
skip-cert-verify: true
servername: ${domain}
network: ws
ws-opts:
path: /vmess
headers:
Host: ${domain}
_______________________________________________________
Format Vmess WS (CDN) Non TLS
_______________________________________________________
- name: vmess-$user-WS (CDN) Non TLS
type: vmess
server: ${domain}
port: 80
uuid: ${uuid}
alterId: 0
cipher: auto
udp: true
tls: false
skip-cert-verify: false
servername: ${domain}
network: ws
ws-opts:
path: /vmess
headers:
Host: ${domain}
_______________________________________________________
Format Vmess gRPC (SNI)
_______________________________________________________
- name: vmess-$user-gRPC (SNI)
server: ${domain}
port: 443
type: vmess
uuid: ${uuid}
alterId: 0
cipher: auto
network: grpc
tls: true
servername: ${domain}
skip-cert-verify: true
grpc-opts:
grpc-service-name: vmess-grpc
_______________________________________________________
Format Vmess WS (CDN) Non TLS Opok TSEL
_______________________________________________________
- name: vmess-$user-WS (CDN) Non TLS
type: vmess
server: ${domain}
port: 80
uuid: ${uuid}
alterId: 0
cipher: auto
udp: true
tls: false
skip-cert-verify: true
servername: comunity.instagram.com
network: ws
ws-opts:
path: : http://tsel.me/worryfree
headers:
Host: ${domain}
_______________________________________________________
Link Vmess Account
_______________________________________________________
Link TLS : vmess://$(echo $VMESS_WS | base64 -w 0)
_______________________________________________________
Link NTLS : vmess://$(echo $VMESS_NON_TLS | base64 -w 0)
_______________________________________________________
Link gRPC : vmess://$(echo $VMESS_GRPC | base64 -w 0)
_______________________________________________________
Link Opok : vmess://$(echo $VMESS_OPOK | base64 -w 0)
_______________________________________________________
END
if [ ${Quota} = '9999' ]; then
TEXT="
◇━━━━━━━━━━━━━━━━━◇
Premium Vmess Account
◇━━━━━━━━━━━━━━━━━◇
User         : ${user}
Domain       : <code>${domain}</code>
Login Limit  : ${iplim} IP
ISP          : ${ISP}
CITY         : ${CITY}
Port TLS     : 443
Port NTLS    : 80, 8080
Port GRPC    : 443
UUID         : <code>${uuid}</code>
AlterId      : 0
Security     : auto
Network      : WS or gRPC
Path         : <code>/vmess</code>
Path Support : <code>https://bug.com/vmess</code>
ServiceName  : <code>vmess-grpc</code>
◇━━━━━━━━━━━━━━━━━◇
Link TLS     :
<code>${vmesslink1}</code>
◇━━━━━━━━━━━━━━━━━◇
Link NTLS    :
<code>${vmesslink2}</code>
◇━━━━━━━━━━━━━━━━━◇
Link GRPC    :
<code>${vmesslink3}</code>
◇━━━━━━━━━━━━━━━━━◇
Format OpenClash :
http://$domain:89/vmess-$user.txt
◇━━━━━━━━━━━━━━━━━◇
Expired Until    : $exp
◇━━━━━━━━━━━━━━━━━◇
$author
◇━━━━━━━━━━━━━━━━━◇
"
else
TEXT="
◇━━━━━━━━━━━━━━━━━◇
Premium Vmess Account
◇━━━━━━━━━━━━━━━━━◇
User         : ${user}
Domain       : <code>${domain}</code>
Login Limit  : ${iplim} IP
Quota Limit  : ${Quota} GB
ISP          : ${ISP}
CITY         : ${CITY}
Port TLS     : 443
Port NTLS    : 80, 8080
Port GRPC    : 443
UUID         : <code>${uuid}</code>
AlterId      : 0
Security     : auto
Network      : WS or gRPC
Path         : <code>/vmess</code>
Path Support : <code>https://bug.com/vmess</code>
ServiceName  : <code>vmess-grpc</code>
◇━━━━━━━━━━━━━━━━━◇
Link TLS     :
<code>${vmesslink1}</code>
◇━━━━━━━━━━━━━━━━━◇
Link NTLS    :
<code>${vmesslink2}</code>
◇━━━━━━━━━━━━━━━━━◇
Link GRPC    :
<code>${vmesslink3}</code>
◇━━━━━━━━━━━━━━━━━◇
Format OpenClash :
http://$domain:89/vmess-$user.txt
◇━━━━━━━━━━━━━━━━━◇
Expired Until    : $exp
◇━━━━━━━━━━━━━━━━━◇
$author
◇━━━━━━━━━━━━━━━━━◇
"
fi
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
user2=$(echo "$user" | cut -c 1-3)
TIME2=$(date +'%Y-%m-%d %H:%M:%S')
TEXT2="
<code>◇━━━━━━━━━━━━━━━━━━━◇</code>
<b>   PEMBELIAN VMESS SUCCES </b>
<code>◇━━━━━━━━━━━━━━━━━━━◇</code>
<b>DOMAIN  :</b> <code>${domain} </code>
<b>CITY    :</b> <code>$CITY </code>
<b>DATE    :</b> <code>${TIME2} WIB </code>
<b>DETAIL  :</b> <code>Trx VMESS </code>
<b>USER    :</b> <code>${user2}xxx </code>
<b>IP      :</b> <code>${iplim} IP </code>
<b>DURASI  :</b> <code>$masaaktif Hari </code>
<code>◇━━━━━━━━━━━━━━━━━━━◇</code>
<i>Notif Pembelian Akun Vmess..</i>"
curl -s --max-time $TIMES -d "chat_id=$CHATID2&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL2 >/dev/null
clear
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}• Premium Vmess Account • ${NC} $COLOR1 $NC" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}User          ${COLOR1}: ${WH}${user}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}ISP           ${COLOR1}: ${WH}$ISP" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}City          ${COLOR1}: ${WH}$CITY" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Domain        ${COLOR1}: ${WH}${domain}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Login Limit  ${COLOR1}: ${WH}${iplim} IP" | tee -a /etc/vmess/akun/log-create-${user}.log
if [ ${Quota} = '9999' ]; then
echo -ne
else
echo -e "$COLOR1 ${NC} ${WH}Quota Limit  ${COLOR1}: ${WH}${Quota} GB" | tee -a /etc/vmess/akun/log-create-${user}.log
fi
echo -e "$COLOR1 ${NC} ${WH}Port TLS      ${COLOR1}: ${WH}443" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Port NTLS    ${COLOR1}: ${WH}80,8080" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Port gRPC     ${COLOR1}: ${WH}443" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}UUID         ${COLOR1}: ${WH}${uuid}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}alterId       ${COLOR1}: ${WH}0" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Security      ${COLOR1}: ${WH}auto" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Network       ${COLOR1}: ${WH}ws" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Path          ${COLOR1}: ${WH}/vmess" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Path Support  ${COLOR1}: ${WH}http://bug/vmess" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}ServiceName   ${COLOR1}: ${WH}vmess-grpc" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${COLOR1}Link Websocket TLS      ${WH}:${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1${NC}${WH}${vmesslink1}${NC}"  | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${COLOR1}Link Websocket NTLS ${WH}: ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1${NC}${WH}${vmesslink2}${NC}"  | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${COLOR1}Link Websocket gRPC     ${WH}: ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1${NC}${WH}${vmesslink3}${NC}"  | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Format Openclash ${COLOR1}:" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}http://$domain:89/vmess-$user.txt${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Expired Akun    ${COLOR1}: ${WH}$exp" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}    $author     " | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo "" | tee -a /etc/vmess/akun/log-create-${user}.log
systemctl restart xray > /dev/null 2>&1
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function trial-vmess(){
clear
cd
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}            ${WH}• Trial Vmess Account •              ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
until [[ $timer =~ ^[0-9]+$ ]]; do
read -p "Expired (Minutes): " timer
done
user=Trial-`</dev/urandom tr -dc X-Z0-9 | head -c4`
iplim=1
Quota=10
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=0
if [ ! -e /etc/vmess ]; then
mkdir -p /etc/vmess
fi
c=$(echo "${Quota}" | sed 's/[^0-9]*//g')
d=$((${c} * 1024 * 1024 * 1024))
if [[ ${c} != "0" ]]; then
echo "${d}" >/etc/vmess/${user}
fi
echo "${iplim}" > /etc/vmess/${user}IP
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\#vmg '"$user $exp $uuid"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
cat> /etc/cron.d/trialvmess${user} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$timer * * * * root /usr/bin/trial vmess $user $uuid $exp
EOF
asu=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
ask=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "none"
}
EOF`
grpc=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "grpc",
"path": "vmess-grpc",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
VMESS_WS=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
VMESS_NON_TLS=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "${domain}",
"tls": "none"
}
EOF`
VMESS_GRPC=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "grpc",
"path": "/vmess-grpc",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
EOF`
VMESS_OPOK=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "http://tsel.me/worryfree",
"type": "none",
"host": "tsel.me",
"tls": "none"
}
EOF`
cat > /home/vps/public_html/vmess-$user.txt <<-END
_______________________________________________________
Format Vmess WS (CDN)
_______________________________________________________
- name: vmess-$user-WS (CDN)
type: vmess
server: ${domain}
port: 443
uuid: ${uuid}
alterId: 0
cipher: auto
udp: true
tls: true
skip-cert-verify: true
servername: ${domain}
network: ws
ws-opts:
path: /vmess
headers:
Host: ${domain}
_______________________________________________________
Format Vmess WS (CDN) Non TLS
_______________________________________________________
- name: vmess-$user-WS (CDN) Non TLS
type: vmess
server: ${domain}
port: 80
uuid: ${uuid}
alterId: 0
cipher: auto
udp: true
tls: false
skip-cert-verify: false
servername: ${domain}
network: ws
ws-opts:
path: /vmess
headers:
Host: ${domain}
_______________________________________________________
Format Vmess gRPC (SNI)
_______________________________________________________
- name: vmess-$user-gRPC (SNI)
server: ${domain}
port: 443
type: vmess
uuid: ${uuid}
alterId: 0
cipher: auto
network: grpc
tls: true
servername: ${domain}
skip-cert-verify: true
grpc-opts:
grpc-service-name: vmess-grpc
_______________________________________________________
Format Vmess WS (CDN) Non TLS Opok TSEL
_______________________________________________________
- name: vmess-$user-WS (CDN) Non TLS
type: vmess
server: ${domain}
port: 80
uuid: ${uuid}
alterId: 0
cipher: auto
udp: true
tls: false
skip-cert-verify: true
servername: comunity.instagram.com
network: ws
ws-opts:
path: http://tsel.me/worryfree
headers:
Host: ${domain}
_______________________________________________________
Link Vmess Account
_______________________________________________________
Link TLS : vmess://$(echo $VMESS_WS | base64 -w 0)
_______________________________________________________
Link NTLS : vmess://$(echo $VMESS_NON_TLS | base64 -w 0)
_______________________________________________________
Link gRPC : vmess://$(echo $VMESS_GRPC | base64 -w 0)
_______________________________________________________
Link Opok : vmess://$(echo $VMESS_OPOK | base64 -w 0)
_______________________________________________________
END
TEXT="
◇━━━━━━━━━━━━━━━━━◇
Trial Premium Vmess Account
◇━━━━━━━━━━━━━━━━━◇
User         : ${user}
Domain       : <code>${domain}</code>
Login Limit  : ${iplim} IP
ISP          : ${ISP}
CITY         : ${CITY}
Port TLS     : 443
Port NTLS    : 80, 8080
Port GRPC    : 443
UUID         : <code>${uuid}</code>
AlterId      : 0
Security     : auto
Network      : WS or gRPC
Path         : <code>/vmess</code>
Path Support : <code>https://bug.com/vmess</code>
ServiceName  : <code>vmess-grpc</code>
◇━━━━━━━━━━━━━━━━━◇
Link TLS     :
<code>${vmesslink1}</code>
◇━━━━━━━━━━━━━━━━━◇
Link NTLS    :
<code>${vmesslink2}</code>
◇━━━━━━━━━━━━━━━━━◇
Link GRPC    :
<code>${vmesslink3}</code>
◇━━━━━━━━━━━━━━━━━◇
Format OpenClash :
http://$domain:89/vmess-$user.txt
◇━━━━━━━━━━━━━━━━━◇
Expired Until    : $timer Minutes
◇━━━━━━━━━━━━━━━━━◇
$author
◇━━━━━━━━━━━━━━━━━◇
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
clear
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}• Trial Premium Vmess Account • ${NC} $COLOR1 $NC" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}User          ${COLOR1}: ${WH}${user}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}ISP           ${COLOR1}: ${WH}$ISP" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}City          ${COLOR1}: ${WH}$CITY" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Domain        ${COLOR1}: ${WH}${domain}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Login Limit  ${COLOR1}: ${WH}${iplim} IP" | tee -a /etc/log-create-.log
echo -e "$COLOR1 ${NC} ${WH}Port TLS      ${COLOR1}: ${WH}443" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Port NTLS    ${COLOR1}: ${WH}80,8080" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Port gRPC     ${COLOR1}: ${WH}443" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}UUID         ${COLOR1}: ${WH}${uuid}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}alterId       ${COLOR1}: ${WH}0" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Security      ${COLOR1}: ${WH}auto" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Network       ${COLOR1}: ${WH}ws" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Path          ${COLOR1}: ${WH}/vmess" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Path Support  ${COLOR1}: ${WH}http://bug/vmess" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}ServiceName   ${COLOR1}: ${WH}vmess-grpc" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${COLOR1}Link Websocket TLS      ${WH}:${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1${NC}${WH}${vmesslink1}${NC}"  | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${COLOR1}Link Websocket NTLS ${WH}: ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1${NC}${WH}${vmesslink2}${NC}"  | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${COLOR1}Link Websocket gRPC     ${WH}: ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1${NC}${WH}${vmesslink3}${NC}"  | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Format Openclash ${COLOR1}:" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}http://$domain:89/vmess-$user.txt${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}Expired Until     ${COLOR1}: ${WH}$timer Minutes" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ${NC} ${WH}    $author     " | tee -a /etc/vmess/akun/log-create-${user}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/vmess/akun/log-create-${user}.log
echo "" | tee -a /etc/vmess/akun/log-create-${user}.log
systemctl restart xray > /dev/null 2>&1
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function renew-vmess(){
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vmg " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Renew Vmess Account ⇲      ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing clients!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Renew Vmess Account ⇲      ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client you want to renew"
echo " ketik [0] kembali kemenu"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
fi
done
read -p "Expired (days): " masaaktif
user=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/#vm $user $exp/#vm $user $exp4/g" /etc/xray/config.json
sed -i "s/#vmg $user $exp/#vmg $user $exp4/g" /etc/xray/config.json
clear
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>   XRAY VMESS RENEW</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>USERNAME :</b> <code>$user </code>
<b>EXPIRED  :</b> <code>$exp4 </code>
<code>◇━━━━━━━━━━━━━━◇</code>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
user2=$(echo "$user" | cut -c 1-3)
TIME2=$(date +'%Y-%m-%d %H:%M:%S')
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>   PEMBELIAN VMESS SUCCES </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>DATE   :</b> <code>${TIME2} WIB </code>
<b>DETAIL   :</b> <code>Trx VMESS </code>
<b>USER :</b> <code>${user2}xxx </code>
<b>DURASI  :</b> <code>$masaaktif Hari </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i> Renew Account From Server..</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID2&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL2 >/dev/null
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " VMESS Account Was Successfully Renewed"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo " Client Name : $user"
echo " Expired On  : $exp4"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
function limit-vmess(){
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vmg " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Limit Vmess Account ⇲      ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing clients!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Limit Vmess Account ⇲      ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client you want to change ip"
echo " ketik [0] kembali kemenu"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
fi
done
clear
until [[ $iplim =~ ^[0-9]+$ ]]; do
read -p "Limit User (IP) or 0 Unlimited: " iplim
done
until [[ $Quota =~ ^[0-9]+$ ]]; do
read -p "Limit User (GB) or 0 Unlimited: " Quota
done
if [ ! -e /etc/vmess ]; then
mkdir -p /etc/vmess
fi
if [ ${iplim} = '0' ]; then
iplim="9999"
fi
if [ ${Quota} = '0' ]; then
Quota="9999"
fi
user=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
echo "${iplim}" >/etc/vmess/${user}IP
c=$(echo "${Quota}" | sed 's/[^0-9]*//g')
d=$((${c} * 1024 * 1024 * 1024))
if [[ ${c} != "0" ]]; then
echo "${d}" >/etc/vmess/${user}
fi
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  XRAY VMESS IP LIMIT</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>USERNAME :</b> <code>$user </code>
<b>IP LIMIT NEW :</b> <code>$iplim IP </code>
<b>QUOTA LIMIT NEW :</b> <code>$Quota GB </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Succes Change this Limit...</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " VMESS Account Was Successfully Change Limit IP"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo " Client Name : $user"
echo " Limit IP    : $iplim IP"
echo " Limit Quota : $Quota GB"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
function del-vmess(){
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vmg " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Delete Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing clients!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Delete Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client you want to remove"
echo " ketik [0] kembali kemenu"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
fi
done
user=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
if [ ! -e /etc/vmess/akundelete ]; then
echo "" > /etc/vmess/akundelete
fi
clear
echo "### $user $exp $uuid" >> /etc/vmess/akundelete
sed -i "/^#vmg $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $user $exp/,/^},{/d" /etc/xray/config.json
rm /etc/vmess/${user}IP
clear
rm /home/vps/public_html/vmess-$user.txt >/dev/null 2>&1
rm /etc/vmess/${user}IP >/dev/null 2>&1
rm /etc/vmess/${user}login >/dev/null 2>&1
systemctl restart xray > /dev/null 2>&1
clear
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  XRAY VMESS DELETE</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>USERNAME :</b> <code>$user </code>
<b>EXPIRED :</b> <code>$exp </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Succes Delete this Username...</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Vmess Account Deleted Successfully"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Client Name : $user"
echo " Expired On  : $exp"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
tim2sec() {
mult=1
arg="$1"
inu=0
while [ ${#arg} -gt 0 ]; do
prev="${arg%:*}"
if [ "$prev" = "$arg" ]; then
curr="${arg#0}"
prev=""
else
curr="${arg##*:}"
curr="${curr#0}"
fi
curr="${curr%.*}"
inu=$((inu + curr * mult))
mult=$((mult * 60))
arg="$prev"
done
echo "$inu"
}
function convert() {
local -i bytes=$1
if [[ $bytes -lt 1024 ]]; then
echo "${bytes} B"
elif [[ $bytes -lt 1048576 ]]; then
echo "$(((bytes + 1023) / 1024)) KB"
elif [[ $bytes -lt 1073741824 ]]; then
echo "$(((bytes + 1048575) / 1048576)) MB"
else
echo "$(((bytes + 1073741823) / 1073741824)) GB"
fi
}
function cek-vmess(){
clear
xrayy=$(cat /var/log/xray/access.log | wc -l)
if [[ xrayy -le 5 ]]; then
systemctl restart xray
fi
xraylimit
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}             ${WH}• VMESS USER ONLINE •               ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
vm=($(cat /etc/xray/config.json | grep "^#vmg" | awk '{print $2}' | sort -u))
echo -n >/tmp/vm
for db1 in ${vm[@]}; do
logvm=$(cat /var/log/xray/access.log | grep -w "email: ${db1}" | tail -n 100)
while read a; do
if [[ -n ${a} ]]; then
set -- ${a}
ina="${7}"
inu="${2}"
anu="${3}"
enu=$(echo "${anu}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
now=$(tim2sec ${timenow})
client=$(tim2sec ${inu})
nowt=$(((${now} - ${client})))
if [[ ${nowt} -lt 40 ]]; then
cat /tmp/vm | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/vm
splvm=$(cat /tmp/vm)
fi
fi
fi
done <<<"${logvm}"
done
if [[ ${splvm} != "" ]]; then
for vmuser in ${vm[@]}; do
vmhas=$(cat /tmp/vm | grep -w "${vmuser}" | wc -l)
tess=0
if [[ ${vmhas} -gt $tess ]]; then
byt=$(cat /etc/limit/vmess/${vmuser})
gb=$(convert ${byt})
lim=$(cat /etc/vmess/${vmuser})
lim2=$(convert ${lim})
echo -e "$COLOR1${NC} USERNAME : \033[0;33m$vmuser"
echo -e "$COLOR1${NC} IP LOGIN : \033[0;33m$vmhas"
echo -e "$COLOR1${NC} USAGE : \033[0;33m$gb"
echo -e "$COLOR1${NC} LIMIT : \033[0;33m$lim2"
echo -e ""
fi
done
fi
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
m-vmess
}
function list-vmess(){
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vmg " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Config Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing clients!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
clear
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Config Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client to view the config"
echo " ketik [0] kembali kemenu"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
fi
done
clear
user=$(grep -E "^#vmg " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
cat /etc/vmess/akun/log-create-${user}.log
cat /etc/vmess/akun/log-create-${user}.log > /etc/notifakun
sed -i 's/\x1B\[1;37m//g' /etc/notifakun
sed -i 's/\x1B\[0;96m//g' /etc/notifakun
sed -i 's/\x1B\[0m//g' /etc/notifakun
TEXT=$(cat /etc/notifakun)
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
clear
function login-vmess(){
clear
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice              $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mAUTO LOCKED USER ALL XRAY      ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 2 ]  \033[1;37mAUTO DELETE USER ALL XRAY    ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 0 ]  \033[1;37mBACK TO MENU    ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $lock =~ ^[0-2]+$ ]]; do
read -p "   Please select numbers 1 sampai 2 : " lock
done
if [[ $lock == "0" ]]; then
menu
elif [[ $lock == "1" ]]; then
clear
echo "lock" > /etc/typexray
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC Succes Ganti Auto Lock  ${NC}"
echo -e "$COLOR1│$NC Jika User Melanggar auto lock Account. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
sleep 1
elif [[ $lock == "2" ]]; then
clear
echo "delete" > /etc/typexray
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC Succes Ganti Auto Delete Account ${NC}"
echo -e "$COLOR1│$NC Jika User Melanggar auto Delete Account. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
sleep 1
fi
type=$(cat /etc/typexray)
if [ $type = "lock" ]; then
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC SILAHKAN TULIS JUMLAH WAKTU UNTUK LOCKED  ${NC}"
echo -e "$COLOR1│$NC BISA TULIS 15 MENIT DLL. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Jumlah Waktu Lock: " -e notif2
echo "${notif2}" > /etc/waktulock
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC SILAHKAN TULIS JUMLAH NOTIFIKASI UNTUK AUTO LOCK    ${NC}"
echo -e "${COLOR1}│ $NC AKUN USER YANG MULTI LOGIN     ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Jika Mau 3x Notif baru kelock tulis 3, dst: " -e notif
echo "$notif" > /etc/vless/notif
echo "$notif" > /etc/vmess/notif
echo "$notif" > /etc/trojan/notif
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC SUCCES GANTI NOTIF LOCK JADI $notif $NC "
echo -e "${COLOR1}│ $NC SUCCES GANTI TIME NOTIF LOCK JADI $notif2 MENIT $NC "
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
else
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC SILAHKAN TULIS JUMLAH WAKTU UNTUK USER YANG MULTI LOGIN   ${NC}"
echo -e "${COLOR1}│ $NC TIAP MENIT JADI NOTIF TIAP BEBERAPA MENIT. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Jika Mau 3menit baru keNotif tulis 3, dst: " -e notif2
echo "# Autokill" >/etc/cron.d/xraylimit
echo "SHELL=/bin/sh" >>/etc/cron.d/xraylimit
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/xraylimit
echo "*/$notif2 * * * *  root /usr/bin/xraylimit" >>/etc/cron.d/xraylimit
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1} $NC SILAHKAN TULIS JUMLAH NOTIFIKASI UNTUK LOCK    ${NC}"
echo -e "${COLOR1} $NC AKUN USER YANG MULTI LOGIN     ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Jika Mau 3x Notif baru kelock tulis 3, dst: " -e notif
echo "$notif" > /etc/vless/notif
echo "$notif" > /etc/vmess/notif
echo "$notif" > /etc/trojan/notif
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC SUCCES GANTI NOTIF LOCK JADI $notif $NC "
echo -e "${COLOR1}│ $NC SUCCES GANTI TIME NOTIF LOCK JADI $notif2 MENIT $NC "
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
fi
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
function lock-vmess(){
clear
cd
if [ ! -e /etc/vmess/listlock ]; then
echo "" > /etc/vmess/listlock
fi
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/vmess/listlock")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Unlock Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing user Lock!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Unlock Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client you want to Unlock"
echo " ketik [0] kembali kemenu"
echo " ketik [999] untuk delete semua Akun"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^### " "/etc/vmess/listlock" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}] to Unlock: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
if [[ ${CLIENT_NUMBER} == '999' ]]; then
rm /etc/vmess/listlock
m-vmess
fi
fi
done
user=$(grep -E "^### " "/etc/vmess/listlock" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/vmess/listlock" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^### " "/etc/vmess/listlock" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
sed -i '/#vmess$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\#vmg '"$user $exp $uuid"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i "/^### $user $exp $uuid/d" /etc/vmess/listlock
systemctl restart xray
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  XRAY VMESS UNLOCKED</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>USERNAME :</b> <code>$user </code>
<b>EXPIRED  :</b> <code>$exp </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Succes Unlocked This Akun...</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Vmess Account Unlock Successfully"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Client Name : $user"
echo " Status  : Unlocked"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
function res-user(){
clear
cd
if [ ! -e /etc/vmess/akundelete ]; then
echo "" > /etc/vmess/akundelete
fi
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/vmess/akundelete")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Restore Vmess Account ⇲    ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing user Expired!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Restore Vmess Account ⇲    ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client you want to Restore"
echo " ketik [0] kembali kemenu"
echo " ketik [999] untuk delete semua Akun"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^### " "/etc/vmess/akundelete" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}] to Unlock: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
if [[ ${CLIENT_NUMBER} == '999' ]]; then
rm /etc/vmess/akundelete
m-vmess
fi
fi
done
until [[ $masaaktif =~ ^[0-9]+$ ]]; do
read -p "Expired (days): " masaaktif
done
until [[ $iplim =~ ^[0-9]+$ ]]; do
read -p "Limit User (IP) or 0 Unlimited: " iplim
done
until [[ $Quota =~ ^[0-9]+$ ]]; do
read -p "Limit Quota (GB) or 0 Unlimited: " Quota
done
if [ ${iplim} = '0' ]; then
iplim="9999"
fi
if [ ${Quota} = '0' ]; then
Quota="9999"
fi
user=$(grep -E "^### " "/etc/vmess/akundelete" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
uuid=$(grep -E "^### " "/etc/vmess/akundelete" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
sed -i '/#vmess$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\#vmg '"$user $exp $uuid"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
echo "${iplim}" >/etc/vmess/${user}IP
c=$(echo "${Quota}" | sed 's/[^0-9]*//g')
d=$((${c} * 1024 * 1024 * 1024))
if [[ ${c} != "0" ]]; then
echo "${d}" >/etc/vmess/${user}
fi
sed -i "/### ${user} ${exp} ${uuid}/d" /etc/vmess/akundelete
systemctl restart xray
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  XRAY VMESS RESTORE</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>USERNAME :</b> <code>$user </code>
<b>IP LIMIT  :</b> <code>$iplim IP </code>
<b>Quota LIMIT  :</b> <code>$Quota GB </code>
<b>EXPIRED  :</b> <code>$exp </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Succes Restore This Akun...</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Vmess Account Restore Successfully"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " DOMAIN : $domain"
echo " ISP  : $ISP $CITY"
echo " USERNAME : $user"
echo " IP LIMIT : $iplim IP"
echo " EXPIRED  : $exp"
echo " Succes to Restore"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
function quota-user(){
clear
cd
if [ ! -e /etc/vmess/userQuota ]; then
echo "" > /etc/vmess/userQuota
fi
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/vmess/userQuota")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Unlock Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "You have no existing user Lock!"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC}${COLBG1}    ${WH}⇱ Unlock Vmess Account ⇲     ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Select the existing client you want to Unlock"
echo " ketik [0] kembali kemenu"
echo " ketik [999] untuk delete semua Akun"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "     No  User   Expired"
grep -E "^### " "/etc/vmess/userQuota" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}] to Unlock: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-vmess
fi
if [[ ${CLIENT_NUMBER} == '999' ]]; then
rm /etc/vmess/userQuota
m-vmess
fi
fi
done
user=$(grep -E "^### " "/etc/vmess/userQuota" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/vmess/userQuota" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^### " "/etc/vmess/userQuota" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
sed -i '/#vmess$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\#vmg '"$user $exp $uuid"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i "/^### $user $exp $uuid/d" /etc/vmess/userQuota
systemctl restart xray
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  XRAY VMESS UNLOCKED</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$ISP $CITY </code>
<b>USERNAME :</b> <code>$user </code>
<b>EXPIRED  :</b> <code>$exp </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Succes Unlocked This Akun...</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Vmess Account Unlock Successfully"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Client Name : $user"
echo " Status  : Unlocked"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-vmess
}
clear
echo -e " $COLOR1╔════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║${NC}${COLBG1}             ${WH}• VMESS PANEL MENU •                   ${NC}$COLOR1║ $NC"
echo -e " $COLOR1╚════════════════════════════════════════════════════╝${NC}"
echo -e " $COLOR1╔════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║ $NC ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}ADD AKUN${NC}         ${WH}[${COLOR1}06${WH}]${NC} ${COLOR1}• ${WH}CEK USER CONFIG${NC}    $COLOR1║ $NC"
echo -e " $COLOR1║ $NC                                                  ${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}TRIAL AKUN${NC}       ${WH}[${COLOR1}07${WH}]${NC} ${COLOR1}• ${WH}CHANGE USER LIMIT${NC}  $COLOR1║ $NC"
echo -e " $COLOR1║ $NC                                                  ${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}RENEW AKUN${NC}       ${WH}[${COLOR1}08${WH}]${NC} ${COLOR1}• ${WH}SETTING LOCK LOGIN${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC                                                  ${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}DELETE AKUN${NC}      ${WH}[${COLOR1}09${WH}]${NC} ${COLOR1}• ${WH}UNLOCK USER LOGIN${NC}  $COLOR1║ $NC"
echo -e " $COLOR1║ $NC                                                  ${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC ${WH}[${COLOR1}05${WH}]${NC} ${COLOR1}• ${WH}CEK USER LOGIN${NC}   ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1}• ${WH}UNLOCK USER QUOTA ${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC                                                  ${NC} $COLOR1║ $NC"
echo -e " $COLOR1║ $NC ${WH}[${COLOR1}00${WH}]${NC} ${COLOR1}• ${WH}GO BACK${NC}          ${WH}[${COLOR1}11${WH}]${NC} ${COLOR1}• ${WH}RESTORE AKUN   ${NC}    $COLOR1║ $NC"
echo -e " $COLOR1╚════════════════════════════════════════════════════╝${NC}"
echo -e " $COLOR1╔═════════════════════════ ${WH}BY${NC} ${COLOR1}═══════════════════════╗ ${NC}"
echo -e "  $COLOR1${NC}              ${WH}   • $author •                 $COLOR1 $NC"
echo -e " $COLOR1╚════════════════════════════════════════════════════╝${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 | 1) clear ; add-vmess ;;
02 | 2) clear ; trial-vmess ;;
03 | 3) clear ; renew-vmess ;;
04 | 4) clear ; del-vmess ;;
05 | 5) clear ; cek-vmess ;;
06 | 6) clear ; list-vmess ;;
07 | 7) clear ; limit-vmess ;;
08 | 8) clear ; login-vmess ;;
09 | 9) clear ; lock-vmess ;;
10 | 10) clear ; quota-user ;;
11 | 11) clear ; res-user ;;
00 | 0) clear ; menu ;;
*) clear ; m-vmess ;;
esac
