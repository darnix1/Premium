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
dnxaz () { echo -e "   \e[97m\033[1;44m${*}\033[0m";}
dnxama() { echo -e "\e[1;37;43m${*}\e[0m";}


#Letras de colores sin contorno 
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
blan() { echo -e "\\033[0;37m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
amacen() { echo -e "\e[1;93m           ${*}"; } 


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
  -bar)cor="\e[38;5;239m════════════════════════════════════════════════════" && echo -e "${cor}${SINCOLOR}";;
  -tit) 
echo -e "\e[1;33m ❰❰❰ ░Ｄ░ ░Ａ░ ░Ｒ░ ░Ｎ░ ░Ｉ░ ░Ｘ░ ❱❱❱ 𝗩𝗲𝗿𝘀𝗶𝗼𝗻: $(cat /opt/.ver)\e[0m"
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
    echo -ne "\e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > " && msg -bra "\e[97m\033[1;41m${a_back:-VOLVER} \033[0;37m"
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

export -f msg
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

err_fun(){
  case $1 in
    1)tput cuu1; tput dl1 && msg -verm "Usuario Nulo"; sleep 2s; tput cuu1; tput dl1;;
    2)tput cuu1; tput dl1 && msg -verm "Usuario con nombre muy corto"; sleep 2s; tput cuu1; tput dl1;;
    3)tput cuu1; tput dl1 && msg -verm "Usuario con nombre muy grande"; sleep 2s; tput cuu1; tput dl1;;
    4)tput cuu1; tput dl1 && msg -verm "Contraseña Nula"; sleep 2s; tput cuu1; tput dl1;;
    5)tput cuu1; tput dl1 && msg -verm "Contraseña muy corta"; sleep 2s; tput cuu1; tput dl1;;
    6)tput cuu1; tput dl1 && msg -verm "Contraseña muy grande"; sleep 2s; tput cuu1; tput dl1;;
    7)tput cuu1; tput dl1 && msg -verm "Duracion Nula"; sleep 2s; tput cuu1; tput dl1;;
    8)tput cuu1; tput dl1 && msg -verm "Duracion invalida utilize numeros"; sleep 2s; tput cuu1; tput dl1;;
    9)tput cuu1; tput dl1 && msg -verm "Duracion maxima y de un año"; sleep 2s; tput cuu1; tput dl1;;
    11)tput cuu1; tput dl1 && msg -verm "Limite Nulo"; sleep 2s; tput cuu1; tput dl1;;
    12)tput cuu1; tput dl1 && msg -verm "Limite invalido utilize numeros"; sleep 2s; tput cuu1; tput dl1;;
    13)tput cuu1; tput dl1 && msg -verm "Limite maximo de 999"; sleep 2s; tput cuu1; tput dl1;;
    14)tput cuu1; tput dl1 && msg -verm "Usuario Ya Existe"; sleep 2s; tput cuu1; tput dl1;;
  esac
}
darnixprom() {
  tput cuu1
  tput dl1
}

biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ifconfig.me)

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
if [ ! -e /etc/xray/sshx/akun ]; then
mkdir -p /etc/xray/sshx/akun
fi
function usernew(){
clear
msg -bar
msg -tit
msg -bar
domen=`cat /etc/xray/domain`
sldomain=`cat /etc/xray/dns`
slkey=`cat /etc/slowdns/server.pub`
TIMES="10"
CHATID=$(cat /etc/per/id)
KEY=$(cat /etc/per/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
clear
msg -bar
msg -tit
msg -bar
dnxaz " MENU DE CREACION DE USUARIOS SSH "
msg -bar
until [[ $Login =~ ^[a-zA-Z0-9_.-]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -ne "\033[1;37m INGRESE EL USUARIO \033[1;33m" && read Login
CLIENT_EXISTS=$(grep -w $Login /etc/xray/ssh | wc -l)
if [[ -z "$Login" ]]; then
err_fun 1 && continue
elif [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
msg -bar
msg -tit
msg -bar
err_fun 14
echo -e "$COLOR1│${WH} Nombre duplicado Por favor cree otro nombre.          $COLOR1│"
echo ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
  usernew
  continue
elif [[ "${Login}" = "1" ]]; then
      return
    elif [[ "${#Login}" -lt "3" ]]; then
      err_fun 2 && continue
    elif [[ "${#Login}" -gt "10" ]]; then
      err_fun 3 && continue
fi
#darnixprom
break
done
#read -p "Password : " Pass
while true; do
        echo -ne "\033[1;37m INGRESE LA CONTRASENA \033[1;33m" && read Pass
        if [[ -z $Pass ]]; then
           err_fun 4 && continue
           elif [[ "${#Pass}" -lt "4" ]]; then
           err_fun 5 && continue
           elif [[ "${#Pass}" -gt "12" ]]; then
           err_fun 6 && continue
        fi
	darnixprom
        break
      done
while true; do
    echo -ne "\033[1;37m TIEMPO DE DURACION DEL USUARIO  \033[1;33m" && read masaaktif
    #read -p ": " diasuser
    if [[ -z "$masaaktif" ]]; then
      err_fun 7 && continue
    elif [[ "$masaaktif" != +([0-9]) ]]; then
      err_fun 8 && continue
    elif [[ "$masaaktif" -gt "360" ]]; then
      err_fun 9 && continue
    fi 
    darnixprom
    break
  done

while true; do
    echo -ne "\033[1;37m LIMITE DE CONEXION \033[1;33m" && read iplim
    #read -p ": " iplim
    if [[ -z "$iplim" ]]; then
      err_fun 11 && continue
    elif [[ "$iplim" != +([0-9]) ]]; then
      err_fun 12 && continue
    elif [[ "$iplim" -gt "999" ]]; then
      err_fun 13 && continue
    fi
    darnixprom
    break
  done

if [ ! -e /etc/xray/sshx ]; then
mkdir -p /etc/xray/sshx
fi
if [ -z ${iplim} ]; then
iplim="0"
fi
echo "${iplim}" >/etc/xray/sshx/${Login}IP
IP=$(curl -sS ifconfig.me);
if [[ -e /etc/cloudfront ]]; then
cloudfront=$(cat /etc/cloudfront)
else
cloudfront="-"
fi
sleep 1
clear
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "### $Login $expi $Pass" >> /etc/xray/ssh
cat > /home/vps/public_html/ssh-$Login.txt <<-END
_______________________________
Format SSH OVPN Account
_______________________________
Username         : $Login
Password         : $Pass
Expired          : $exp
_______________________________
Host             : $domen
ISP              : $ISP
CITY             : $CITY
Login Limit      : ${iplim} IP
Port OpenSSH     : 22
Port Dropbear    : 143, 109
Port SSH WS      : 80, 8080
Port SSH SSL WS  : 443
Port SSL/TLS     : 8443, 8880
Port OVPN WS SSL : 2086
Port OVPN SSL    : 990
Port OVPN TCP    : 1194
Port OVPN UDP    : 2200,
BadVPN UDP       : 7100, 7300, 7300
_______________________________
Host Slowdns    : $sldomain
Port Slowdns     : 80, 443, 53
Pub Key          : $slkey
_______________________________
SSH UDP VIRAL : $domen:1-65535@$Login:$Pass
_______________________________
HTTP COSTUM : $domen:80@$Login:$Pass
_______________________________
Payload WS/WSS   :
GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]
_______________________________
OpenVPN SSL      : http://$domen:89/ssl.ovpn
OpenVPN TCP      : http://$domen:89/tcp.ovpn
OpenVPN UDP      : http://$domen:89/udp.ovpn
_______________________________
END
if [[ -e /etc/cloudfront ]]; then
TEXT="
◇━━━━━━━━━━━━━━━━━◇
Cuenta Premium SSH
◇━━━━━━━━━━━━━━━━━◇
Usuario       :  <code>$Login</code>
Password      :  <code>$Pass</code>
Expira el     :  $exp
◇━━━━━━━━━━━━━━━━━◇
ISP              :  $ISP
CITY             :  $CITY
Host             :  <code>$domen</code>
Login Limit      :  ${iplim} IP
Port OpenSSH    :  22
Port Dropbear    :  109, 143
Port SSH WS     :  80, 8080
Port SSH SSL WS :  443
Port SSL/TLS     :  8443,8880
Port OVPN WS SSL :  2086
Port OVPN SSL    :  990
Port OVPN TCP    :  1194
Port OVPN UDP    :  2200
Proxy Squid        :  3128
BadVPN UDP       :  7100, 7300, 7300
◇━━━━━━━━━━━━━━━━━◇
SSH UDP VIRAL : <code>$domen:1-65535@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
APP HTTP COSTUM WS  
<code>$domen:80@$Login:$Pass</code>
<code>$domen:443@$Login:$Pass</code>
<code>$domen:8443@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
Host Slowdns    :  <code>$sldomain</code>
Port Slowdns     :  80, 443, 53
Pub Key          :  <code> $slkey</code>
◇━━━━━━━━━━━━━━━━━◇
Payload WS/WSS   :
<code>GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]</code>
◇━━━━━━━━━━━━━━━━━◇
OpenVPN SSL      :  http://$domen:89/ssl.ovpn
OpenVPN TCP      :  http://$domen:89/tcp.ovpn
OpenVPN UDP      :  http://$domen:89/udp.ovpn
◇━━━━━━━━━━━━━━━━━◇
Save Link Account: http://$domen:89/ssh-$Login.txt
◇━━━━━━━━━━━━━━━━━◇
$author
◇━━━━━━━━━━━━━━━━━◇
"
else
TEXT="
◇━━━━━━━━━━━━━━━━━◇
Cuenta Premium SSH
◇━━━━━━━━━━━━━━━━━◇
Usuario        :  <code>$Login</code>
Password       :  <code>$Pass</code>
Expira el      :  $exp
◇━━━━━━━━━━━━━━━━━◇
ISP              :  $ISP
CITY             :  $CITY
Host             :  <code>$domen</code>
Login Limit      :  ${iplim} IP
Port OpenSSH    :  22
Port Dropbear    :  109, 143
Port SSH WS     :  80, 8080
Port SSH SSL WS :  443
Port SSL/TLS     :  8443,8880
Port OVPN WS SSL :  2086
Port OVPN SSL    :  990
Port OVPN TCP    :  1194
Port OVPN UDP    :  2200
Proxy Squid        :  3128
BadVPN UDP       :  7100, 7300, 7300
◇━━━━━━━━━━━━━━━━━◇
SSH UDP VIRAL : <code>$domen:1-65535@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
APP HTTP COSTUM WS 
<code>$domen:80@$Login:$Pass</code>
<code>$domen:443@$Login:$Pass</code>
<code>$domen:8443@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
Payload WS/WSS   :
<code>GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]</code>
◇━━━━━━━━━━━━━━━━━◇
OpenVPN SSL      :  http://$domen:89/ssl.ovpn
OpenVPN TCP      :  http://$domen:89/tcp.ovpn
OpenVPN UDP      :  http://$domen:89/udp.ovpn
◇━━━━━━━━━━━━━━━━━◇
Save Link Account: http://$domen:89/ssh-$Login.txt
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
user2=$(echo "$Login" | cut -c 1-3)
TIME2=$(date +'%Y-%m-%d %H:%M:%S')
TEXT2="
<code>◇━━━━━━━━━━━━━━━━━◇</code>
<b>   CUENTA SSH EXITOSA </b>
<code>◇━━━━━━━━━━━━━━━━━◇</code>
<b>DOMINIO  :</b> <code>${domain} </code>
<b>PAIS     :</b> <code>$CITY </code>
<b>FECHA    :</b> <code>${TIME2} WIB </code>
<b>DETALLE  :</b> <code>Trx SSH </code>
<b>USUARIO  :</b> <code>${user2}xxx </code>
<b>IP       :</b> <code>${iplim} IP </code>
<b>DURACION :</b> <code>$masaaktif Hari </code>
<code>◇━━━━━━━━━━━━━━━━━◇</code>
<i>Notificación de cuenta SSH creado..</i>"
curl -s --max-time $TIMES -d "chat_id=$CHATID2&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL2 >/dev/null
clear
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC} ${WH}• SSH Premium Account  • " | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Usuario   ${COLOR1}: ${WH}$Login"  | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Password   ${COLOR1}: ${WH}$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Expira en ${COLOR1}: ${WH}$exp"  | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}ISP        ${COLOR1}: ${WH}$ISP" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}City       ${COLOR1}: ${WH}$CITY" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Host       ${COLOR1}: ${WH}$domen" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Login Limit${COLOR1}: ${WH}${iplim} IP" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OpenSSH    ${COLOR1}: ${WH}22" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Dropbear   ${COLOR1}: ${WH}109, 143" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}SSH-WS     ${COLOR1}: ${WH}80,8080" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}SSH-SSL-WS ${COLOR1}: ${WH}443" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}SSL/TLS    ${COLOR1}: ${WH}8443,8880" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Ovpn Ws    ${COLOR1}: ${WH}2086" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Port TCP   ${COLOR1}: ${WH}1194" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Port UDP   ${COLOR1}: ${WH}2200,1-65535" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Port SSL   ${COLOR1}: ${WH}990" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OVPN TCP   ${COLOR1}: ${WH}http://$domen:89/tcp.ovpn" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OVPN UDP   ${COLOR1}: ${WH}http://$domen:89/udp.ovpn" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OVPN SSL   ${COLOR1}: ${WH}http://$domen:89/ssl.ovpn" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}UDPGW      ${COLOR1}: ${WH}7100-7300" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}UDP VIRAL${COLOR1}: ${WH}$domen:1-65535@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}HTTP COSTUM${COLOR1}: ${WH}$domen:80@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}HTTP COSTUM${COLOR1}: ${WH}$domen:443@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}HTTP COSTUM${COLOR1}: ${WH}$domen:8443@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}  ${WH}Payload WS/WSS${COLOR1}: ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1${NC}${WH}GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}  ${WH}Save Link Acount    : " | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}  ${WH}http://$domen:89/ssh-$Login.txt${NC}$COLOR1 $NC" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}    ${WH}• $author •${NC}                 $COLOR1 $NC" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo "" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}
function trial(){
clear
domen=`cat /etc/xray/domain`
sldomain=`cat /etc/xray/dns`
slkey=`cat /etc/slowdns/server.pub`
TIMES="10"
CHATID=$(cat /etc/per/id)
KEY=$(cat /etc/per/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
clear
IP=$(curl -sS ifconfig.me)
cd
msg -bar
msg -tit
msg -bar
amacen " USUARIO SSH TEMPORAL"
echo ""

# Pedir al usuario que introduzca el tiempo de expiración en minutos
until [[ $timer =~ ^[0-9]+$ ]]; do
    read -p "Ingresa los (Minutos): " timer
done

# Generar credenciales de usuario aleatorias
Login=Trial-`</dev/urandom tr -dc X-Z0-9 | head -c4`
Pass=1
iplim=1

# Crear directorio si no existe
if [ ! -e /etc/xray/sshx ]; then
    mkdir -p /etc/xray/sshx
fi

# Definir el límite de IP si no está definido
if [ -z ${iplim} ]; then
    iplim="0"
fi

# Crear el archivo de límite de IP
echo "$iplim" > /etc/xray/sshx/${Login}IP

# Configurar la cuenta de usuario SSH
useradd -e `date -d "0 days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n" | passwd $Login &> /dev/null
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "### $Login $exp $Pass" >> /etc/xray/ssh

# Programar la eliminación del usuario después de los minutos especificados
echo "/bin/bash -c 'userdel -f $Login; systemctl restart sshd; sed -i \"/### $Login $exp $Pass/d\" /etc/xray/ssh; rm -f /home/vps/public_html/ssh-$Login.txt; rm -f /etc/xray/sshx/${Login}IP'" | at now + $timer minutes

# Crear archivo de información de usuario
cat > /home/vps/public_html/ssh-$Login.txt <<-END
_______________________________
Format SSH OVPN Account
_______________________________
Username         : $Login
Password         : $Pass
Expired          : $timer Minutes
_______________________________
Host             : $domen
ISP              : $ISP
CITY             : $CITY
Login Limit      : ${iplim} IP
Port OpenSSH     : 22
Port Dropbear    : 143, 109
Port SSH WS      : 80, 8080
Port SSH SSL WS  : 443
Port SSL/TLS     : 8443, 8880
Port OVPN WS SSL : 2086
Port OVPN SSL    : 990
Port OVPN TCP    : 1194
Port OVPN UDP    : 2200,
BadVPN UDP       : 7100, 7300, 7300
_______________________________
Host Slowdns    : $sldomain
Port Slowdns     : 80, 443, 53
Pub Key          : $slkey
_______________________________
SSH UDP VIRAL : $domen:1-65535@$Login:$Pass
_______________________________
HTTP COSTUM : $domen:80@$Login:$Pass
_______________________________
Payload WS/WSS   :
GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]
_______________________________
OpenVPN SSL      : http://$domen:89/ssl.ovpn
OpenVPN TCP      : http://$domen:89/tcp.ovpn
OpenVPN UDP      : http://$domen:89/udp.ovpn
_______________________________
END
echo userdel -f "$Login" | at now + $timer minutes
echo "tunnel ssh ${Login}" | at now +$timer minutes &> /dev/null

if [[ -e /etc/cloudfront ]]; then
TEXT="
◇━━━━━━━━━━━━━━━━━◇
USUARIO TEMPORAL SSH
◇━━━━━━━━━━━━━━━━━◇
Usuario        :  <code>$Login</code>
Password       :  <code>$Pass</code>
Expira en      :  $timer Minutos
◇━━━━━━━━━━━━━━━━━◇
ISP              :  $ISP
CITY             :  $CITY
Host             :  <code>$domen</code>
Login Limit      :  ${iplim} IP
Port OpenSSH    :  22
Port Dropbear    :  109, 143
Port SSH WS     :  80, 8080
Port SSH SSL WS :  443
Port SSL/TLS     :  8443,8880
Port OVPN WS SSL :  2086
Port OVPN SSL    :  990
Port OVPN TCP    :  1194
Port OVPN UDP    :  2200
Proxy Squid        :  3128
BadVPN UDP       :  7100, 7300, 7300
◇━━━━━━━━━━━━━━━━━◇
SSH UDP VIRAL : <code>$domen:1-65535@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
APP HTTP COSTUM WS 
<code>$domen:80@$Login:$Pass</code>
<code>$domen:443@$Login:$Pass</code>
<code>$domen:8443@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
Payload WS/WSS   :
<code>GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]</code>
◇━━━━━━━━━━━━━━━━━◇
OpenVPN SSL      :  http://$domen:89/ssl.ovpn
OpenVPN TCP      :  http://$domen:89/tcp.ovpn
OpenVPN UDP      :  http://$domen:89/udp.ovpn
◇━━━━━━━━━━━━━━━━━◇
Save Link Account: http://$domen:89/ssh-$Login.txt
◇━━━━━━━━━━━━━━━━━◇
$author
◇━━━━━━━━━━━━━━━━━◇
"
else
TEXT="
◇━━━━━━━━━━━━━━━━━◇
USUARIO TEMPORAL SSH
◇━━━━━━━━━━━━━━━━━◇
Usuario        :  <code>$Login</code>
Password       :  <code>$Pass</code>
Expira en      :  $timer Minutes
◇━━━━━━━━━━━━━━━━━◇
ISP              :  $ISP
CITY             :  $CITY
Host             :  <code>$domen</code>
Login Limit      :  ${iplim} IP
Port OpenSSH    :  22
Port Dropbear    :  109, 143
Port SSH WS     :  80, 8080
Port SSH SSL WS :  443
Port SSL/TLS     :  8443,8880
Port OVPN WS SSL :  2086
Port OVPN SSL    :  990
Port OVPN TCP    :  1194
Port OVPN UDP    :  2200
Proxy Squid        :  3128
BadVPN UDP       :  7100, 7300, 7300
◇━━━━━━━━━━━━━━━━━◇
SSH UDP VIRAL : <code>$domen:1-65535@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
APP HTTP COSTUM WS  
<code>$domen:80@$Login:$Pass</code>
<code>$domen:443@$Login:$Pass</code>
<code>$domen:8443@$Login:$Pass</code>
◇━━━━━━━━━━━━━━━━━◇
Payload WS/WSS   :
<code>GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]</code>
◇━━━━━━━━━━━━━━━━━◇
OpenVPN SSL      :  http://$domen:89/ssl.ovpn
OpenVPN TCP      :  http://$domen:89/tcp.ovpn
OpenVPN UDP      :  http://$domen:89/udp.ovpn
◇━━━━━━━━━━━━━━━━━◇
Save Link Account: http://$domen:89/ssh-$Login.txt
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
cat > /etc/cron.d/trialssh${Login} <<- EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$timer * * * * root /usr/bin/trialssh $Login ${timer}
EOF
chmod 644 /etc/cron.d/trialssh${Login}
clear
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC} ${WH}• Demo SSH Premium  • " | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Usuario   ${COLOR1}: ${WH}$Login"  | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Password   ${COLOR1}: ${WH}$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Expira en ${COLOR1}: ${WH}$timer Minutos"  | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}ISP        ${COLOR1}: ${WH}$ISP" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}City       ${COLOR1}: ${WH}$CITY" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Host       ${COLOR1}: ${WH}$domen" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Login Limit${COLOR1}: ${WH}${iplim} IP" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OpenSSH    ${COLOR1}: ${WH}22" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Dropbear   ${COLOR1}: ${WH}109, 143" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}SSH-WS     ${COLOR1}: ${WH}80,8080" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}SSH-SSL-WS ${COLOR1}: ${WH}443" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}SSL/TLS    ${COLOR1}: ${WH}8443,8880" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Ovpn Ws    ${COLOR1}: ${WH}2086" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Port TCP   ${COLOR1}: ${WH}1194" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Port UDP   ${COLOR1}: ${WH}2200,1-65535" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}Port SSL   ${COLOR1}: ${WH}990" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OVPN TCP   ${COLOR1}: ${WH}http://$domen:89/tcp.ovpn" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OVPN UDP   ${COLOR1}: ${WH}http://$domen:89/udp.ovpn" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}OVPN SSL   ${COLOR1}: ${WH}http://$domen:89/ssl.ovpn" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}UDPGW      ${COLOR1}: ${WH}7100-7300" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}UDP VIRAL${COLOR1}: ${WH}$domen:1-65535@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}HTTP COSTUM${COLOR1}: ${WH}$domen:80@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}HTTP COSTUM${COLOR1}: ${WH}$domen:443@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 $NC  ${WH}HTTP COSTUM${COLOR1}: ${WH}$domen:8443@$Login:$Pass" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}  ${WH}Payload WS/WSS${COLOR1}: ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1${NC}${WH}GET / HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: ws[crlf][crlf]${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}  ${WH}Save Link Acount    : " | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}  ${WH}http://$domen:89/ssh-$Login.txt${NC}$COLOR1 $NC" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ${NC}    ${WH}• $author •${NC}                 $COLOR1 $NC" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo -e "$COLOR1 ◇━━━━━━━━━━━━━━━━━◇ ${NC}" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
echo "" | tee -a /etc/xray/sshx/akun/log-create-${Login}.log
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}
function renew(){
clear

TIMES="10"
CHATID=$(cat /etc/per/id)
KEY=$(cat /etc/per/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
domain=$(cat /etc/xray/domain)
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/ssh")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
msg -bar
msg -tit
msg -bar
amacen " RENOVAR USUARIOS SSH PREMIUM"
echo ""
msg -bar
red " No existe Ningun Usuario"
msg -bar
echo ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
fi
msg -bar
msg -tit
msg -bar
amacen " RENOVAR USUARIOS SSH PREMIUM"
msg -bar
blan " Escoge un usuario para renovar "
blan " Presiona 0 para volver"
msg -bar
echo -e "\033[0;37m" 
grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Seleccione un cliente [1]: " CLIENT_NUMBER
else
read -rp "Seleccione un cliente [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-sshovpn
fi
fi
done
User=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
Pass=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "Dias a Agregar : " Days
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $Days))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
passwd -u $User
usermod -e  $exp4 $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
sed -i "s/### $User $exp/### $User $exp4/g" /etc/xray/ssh >/dev/null
echo -e "\033[0m"
clear
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  USUARIO SSH RENOVADO</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO :</b> <code>${domain} </code>
<b>IP      :</b> <code>$ISP $CITY </code>
<b>USUARIO :</b> <code>$User </code>
<b>NUEVA EXPIRACION  :</b> <code>$exp4 </code>
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
user2=$(echo "$User" | cut -c 1-3)
TIME2=$(date +'%Y-%m-%d %H:%M:%S')
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>   RENOVACION EXITOSA </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN   :</b> <code>${domain} </code>
<b>ISP      :</b> <code>$CITY </code>
<b>FECHA   :</b> <code>${TIME2} WIB</code>
<b>DETALLE   :</b> <code>Trx SSH </code>
<b>USUARIO :</b> <code>${user2}xxx </code>
<b>DURACIÓN  :</b> <code>$Days Hari </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Cuenta Renovado desde el servidor..</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID2&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL2 >/dev/null
clear
msg -bar
msg -tit
msg -bar
amacen " RENOVACION DE USUARIO EXITOSAMENTE "
echo ""
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│"
echo -e "$COLOR1│ ${WH}Nombre de usuario  : $User"
echo -e "$COLOR1│ ${WH}Dias agregados     : $Days Dias"
echo -e "$COLOR1│ ${WH}Expira el          : $exp4"
echo -e "$COLOR1│"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
fi
echo ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}
function hapus(){
clear

NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/ssh")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
msg -bar
msg -tit
msg -bar
amacen " ELIMINACION DE USUARIOS SSH"
msg -bar
red " Aun no cuentas con ningun usuario"
msg -bar
echo ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
fi
msg -bar
msg -tit
msg -bar
amacen " ELIMINACION DE USUARIOS SSH"
echo ""
msg -bar
blan "Por favor selecciona un usuario a eliminar"
blan "Presiona 0 para volver "
msg -bar
echo -e "\033[0;37m" # Esto establece el color blanco para la salida
grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Seleccione un cliente [1]: " CLIENT_NUMBER
else
read -rp "Seleccione un cliente [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-sshovpn
fi
fi
done
Pengguna=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
Days=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
Pass=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $Pengguna $Days $Pass/d" /etc/xray/ssh
rm /home/vps/public_html/ssh-$Pengguna.txt >/dev/null 2>&1
rm /etc/xray/sshx/${Pengguna}IP >/dev/null 2>&1
rm /etc/xray/sshx/${Pengguna}login >/dev/null 2>&1
if getent passwd $Pengguna > /dev/null 2>&1; then
userdel $Pengguna > /dev/null 2>&1
echo -e "Usuario $Pengguna fue removido."
else
echo -e "Fallo: Usuario $Pengguna No existe."
fi
echo -e "\033[0m" # Restablece el color al valor predeterminado antes de la notificación
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  ELIMINACION SSH OVPN</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO   :</b> <code>${domain} </code>
<b>IP      :</b> <code>$ISP $CITY </code>
<b>USUARIO :</b> <code>$Pengguna </code>
<b>EXPIRADO  :</b> <code>$Days </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Eliminacion de usuario exitoso...</i>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
cd
if [ ! -e /etc/tele ]; then
echo -ne
else
echo "$TEXT" > /etc/notiftele
bash /etc/tele
fi
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}
function cekconfig(){
clear

ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
IP=$(curl -sS ifconfig.me);
domen=`cat /etc/xray/domain`
sldomain=`cat /etc/xray/dns`
slkey=`cat /etc/slowdns/server.pub`
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/ssh")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
msg -bar
msg -tit
msg -bar
amacen " CONFIGURACION DE USUARIOS SSH"
echo ""
msg -bar
red " No cuentas con ningun usuario para ver su configuración"
msg -bar
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
fi
msg -bar
msg -tit
msg -bar
amacen " CONFIGURACION DE USUARIOS SSH"
echo ""
msg -bar
blan " Selecciona el usuario para verificar su configuracion"
blan " Presiona 0 para volver "
msg -bar
grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Select one client [1]: " CLIENT_NUMBER
else
read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-sshovpn
fi
fi
done
Login=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
cat /etc/xray/sshx/akun/log-create-${Login}.log
cat /etc/xray/sshx/akun/log-create-${Login}.log > /etc/notifakun
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
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}
function hapuslama(){
clear
msg -bar
msg -tit
msg -bar
amacen " • LISTA DE USUARIOS SSH CREADOS •"
echo ""
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                 ${WH}• MEMBER SSH •                 ${NC}$COLOR1$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo "USERNAME          EXP DATE          STATUS"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
while read expired
do
AKUN="$(echo $expired | cut -d: -f1)"
ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
status="$(passwd -S $AKUN | awk '{print $2}' )"
if [[ $ID -ge 1000 ]]; then
if [[ "$status" = "L" ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "LOCKED"
else
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "UNLOCKED"
fi
fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo "Account number: $JUMLAH user"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
}
function cek(){
clear&clear
TIMES="10"
CHATID=$(cat /etc/per/id)
KEY=$(cat /etc/per/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
domain=$(cat /etc/xray/domain)
author=$(cat /etc/profil)
msg -bar
msg -tit
msg -bar
amacen " • SSH USUARIOS EN LINEA •"
echo ""
rm -rf /tmp/ssh2
systemctl restart ws-stunnel > /dev/null 2>&1
sleep 3
if [ -e "/var/log/auth.log" ]; then
LOG="/var/log/auth.log";
fi
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /etc/user.txt
username1=( `cat "/etc/user.txt" `);
i="0";
for user in "${username1[@]}"
do
username[$i]=`echo $user | sed 's/'\''//g'`;
jumlah[$i]=0;
i=$i+1;
done
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${proc[@]}"
do
cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh2
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
NUM=`cat /tmp/log-db-pid.txt | wc -l`;
USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
TIME=$(date +'%H:%M:%S')
echo "$USER $TIME : $IP" >>/tmp/ssh2
i=0;
for user1 in "${username[@]}"
do
if [ "$USER" == "$user1" ]; then
jumlah[$i]=`expr ${jumlah[$i]} + 1`;
pid[$i]="${pid[$i]} $PID"
fi
i=$i+1;
done
fi
done
j="0";
for i in ${!username[*]}
do
limitip="0"
if [[ ${jumlah[$i]} -gt $limitip ]]; then
sship=$(cat /tmp/ssh2  | grep -w "${username[$i]}" | wc -l)
echo -e "$COLOR1${NC} USUARIO : \033[0;33m${username[$i]}";
echo -e "$COLOR1${NC} IP LOGIN : \033[0;33m$sship";
echo -e ""
fi
done
if [ -f "/etc/openvpn/server/openvpn-tcp.log" ]; then
echo " "
cat /etc/openvpn/server/openvpn-tcp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' > /tmp/vpn-login-tcp.txt
cat /tmp/vpn-login-tcp.txt
fi
if [ -f "/etc/openvpn/server/openvpn-udp.log" ]; then
echo " "
cat /etc/openvpn/server/openvpn-udp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' > /tmp/vpn-login-udp.txt
cat /tmp/vpn-login-udp.txt
fi
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
}
function limitssh(){
clear
cd
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/ssh")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
msg -bar
msg -tit
msg -bar
amacen "• CAMBIAR LIMITE IP CUENTAS SSH •"
echo "" 
msg -bar
echo ""
red "Actualmente no tienes ningun usuario"
echo ""
msg -bar
echo ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
fi
msg -bar
msg -tit
msg -bar
amacen " • CAMBIAR LIMITE IP CUENTAS SSH •"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Seleccione el cliente al que desea cambiar la IP Login"
echo " Presiona [0] para volver"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Seleccione un cliente [1]: " CLIENT_NUMBER
else
read -rp "Seleccione un cliente [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-sshovpn
fi
fi
done
until [[ $iplim =~ ^[0-9]+$ ]]; do
read -p "Limite Usuario (IP) Nuevo: " iplim
done
if [ ! -e /etc/xray/sshx ]; then
mkdir -p /etc/xray/sshx
fi
if [ -z ${iplim} ]; then
iplim="0"
fi
user=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/ssh" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
echo "${iplim}" >/etc/xray/sshx/${user}IP
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  SSH IP LIMITE</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO   :</b> <code>${domain} </code>
<b>IP      :</b> <code>$ISP $CITY </code>
<b>USUARIO :</b> <code>$user </code>
<b>EXPIRA  :</b> <code>$exp </code>
<b>IP LIMITE NUEVO :</b> <code>$iplim IP </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>LIMITE de IP nuevo exitoso...</i>
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
msg -bar
msg -tit
msg -bar
amacen " • CAMBIAR LIMITE IP CUENTAS SSH  •"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " La cuenta SSH cambió correctamente el límite de IP"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo " Nombre del cliente : $user"
echo " Limite IP    : $iplim IP"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
}

function liser () {
clear
msg -bar
msg -tit
msg -bar
amacen " • LISTA DE CLIENTES EN EL SERVIDOR •"
echo ""
msg -bar
echo -e " \033[1;37m\033[41mUSUARIO          EXP FECHA        ESTADO   \033[0m"
msg -bar
unlocked_count=0

while IFS=':' read -r user _ uid _; do
    if [[ $uid -ge 1000 && $user != "nobody" ]]; then
        exp=$(chage -l "$user" | grep "Account expires" | awk -F": " '{print $2}')
        status=$(passwd -S "$user" | awk '{print $2}')
        if [[ "$exp" != "never" ]]; then
            if [[ "$status" = "L" ]]; then
		printf "\033[0;37m%-17s %2s %-17s %2s \033[0m\n" "  $user" "$exp     " "LOCKED"
            else
		printf "\033[0;37m%-17s %2s %-17s %2s \033[0m\n" "  $user" "$exp     " "UNLOCKED"
                ((unlocked_count++))
            fi
        fi
    fi
done < /etc/passwd

msg -bar
echo -e " \033[1;37m  TOTAL \033[1;33m [ \033[1;36m$unlocked_count\033[1;33m ]\033[1;37m CLIENTES EN TU VPS "
msg -bar
echo -e ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}
function listssh(){
clear
msg -bar
msg -tit
msg -bar
amacen " • AUTO BLOQUEO Y ELIMINAR SSH MULTILOGIN•"
echo ""
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mAUTO BLOQUEO USER SSH      ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 2 ]  \033[1;37mAUTO ELIMINAR USER SSH    ${NC}"
echo -e "$COLOR1│  [ 0 ]  \033[1;37mPresiona 0 para volver    ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $lock =~ ^[0-2]+$ ]]; do
read -p "   Por favor seleccione los números 1 o 2 : " lock
done
if [[ $lock == "0" ]]; then
menu
elif [[ $lock == "1" ]]; then
clear
msg -bar
msg -tit
msg -bar
amacen " • CONFIGURACION MULTILOGIN•"
echo ""
echo "lock" > /etc/typessh
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC Si el limite del usuario otorgado es 1 ${NC}"
echo -e "$COLOR1│$NC y se conecta en dos dispositivos este lo eliminara automático. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
sleep 1
elif [[ $lock == "2" ]]; then
clear
msg -bar
msg -tit
msg -bar
amacen " • CONFIGURACION MULTILOGIN  •"
echo ""
echo "delete" > /etc/typessh
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC Si el limite del usuario otorgado es 1${NC}"
echo -e "$COLOR1│$NC y se conecta en dos dispositivos este lo elimira en automático. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
sleep 1
fi
type=$(cat /etc/typessh)
if [ $type = "lock" ]; then
clear
msg -bar
msg -tit
msg -bar
amacen " • CONFIGURACION MULTILOGIN•"
echo ""
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC POR FAVOR ESCRIBA LA CANTIDAD DE TIEMPO PARA EL BLOQUEO  ${NC}"
echo -e "$COLOR1│$NC PUEDE ESCRIBIR EN 15 MINUTOS ETC.. ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Tiempo total de bloqueo: " -e notif2
echo "${notif2}" > /etc/waktulockssh
clear
msg -bar
msg -tit
msg -bar
amacen " • CONFIGURACION MULTILOGIN•"
echo ""
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC POR FAVOR ESCRIBA EL NÚMERO DE NOTIFICACIONES PARA AUTO BLOQUEO    ${NC}"
echo -e "${COLOR1}│ $NC CUENTAS DE USUARIOS DE INICIO DE SESIÓN MÚLTIPLE     ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Si desea notificaciones 3x, escriba 3: " -e notif
cd /etc/xray/sshx
echo "$notif" > notif
clear
msg -bar
msg -tit
msg -bar
amacen " • CONFIGURACION MULTILOGIN•"
echo ""
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC CAMBIANDO CON ÉXITO LA NOTIFICACIÓN DE BLOQUEO PARA QUE $notif $NC "
echo -e "${COLOR1}│ $NC CAMBIANDO CON ÉXITO EL TIEMPO DE NOTIFICACIÓN DE BLOQUEO PARA QUE $notif2 MINUTO $NC "
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
else
msg -bar
msg -tit
msg -bar
amacen " • CONFIGURACION MULTILOGIN•"
echo ""
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│$NC POR FAVOR ESCRIBA LA CANTIDAD DE TIEMPO PARA ESCANEAR ${NC}"
echo -e "$COLOR1│$NC USUARIOS QUE SON MULTI LOGIN . ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Escribir tiempo de escaneo (Minuto) : " -e notif2
echo "# Autokill" >/etc/cron.d/tendang
echo "SHELL=/bin/sh" >>/etc/cron.d/tendang
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/tendang
echo "*/$notif2 * * * *  root /usr/bin/tendang" >>/etc/cron.d/tendang
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC POR FAVOR ESCRIBA EL NÚMERO DE NOTIFICACIONES PARA AUTO BLOQUEO    ${NC}"
echo -e "${COLOR1}│ $NC CUENTAS DE USUARIOS DE INICIO DE SESIÓN MÚLTIPLE     ${NC}"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
read -rp "   Si desea notificaciones 3x, escriba 3, : " -e notif
cd /etc/xray/sshx
echo "$notif" > notif
clear
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}${COLBG1}           ${WH}• SETTING MULTI LOGIN •             ${NC}$COLOR1│ $NC"
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e "${COLOR1}│ $NC CAMBIANDO CON ÉXITO LA NOTIFICACIÓN DE BLOQUEO PARA QUE $notif $NC "
echo -e "${COLOR1}│ $NC NOTIFIQUE EN  $notif2 MINUTO $NC "
echo -e "$COLOR1└───────────────────────────────────────────────┘${NC}"
fi
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
}
function lockssh(){
clear
cd
if [ ! -e /etc/xray/sshx/listlock ]; then
echo "" > /etc/xray/sshx/listlock
fi
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/sshx/listlock")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
msg -bar
msg -tit
msg -bar
amacen " • DESBLOQUEAR CUENTA SSH •"
echo ""
msg -bar
red " Actualmente no tienes ningun usuario bloqueado"
msg -bar
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
fi
clear
msg -bar
msg -tit
msg -bar
amacen " • DESBLOQUEAR CUENTA SSH •"
echo ""
msg -bar
blan " Selecciona el usuario que deseas desbloquear"
red " Presiona 0 para volver al menu"
msg -bar
echo -e "\033[1;37m\033[41mNo     Usuario       Expira  \033[0m"
grep -E "^### " "/etc/xray/sshx/listlock" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
if [[ ${CLIENT_NUMBER} == '1' ]]; then
read -rp "Selecciona el usuario [1]: " CLIENT_NUMBER
else
read -rp "Selecciona el usuario [1-${NUMBER_OF_CLIENTS}] to Unlock: " CLIENT_NUMBER
if [[ ${CLIENT_NUMBER} == '0' ]]; then
m-sshovpn
fi
if [[ ${CLIENT_NUMBER} == 'clear' ]]; then
rm /etc/xray/sshx/listlock
m-sshovpn
fi
fi
done
user=$(grep -E "^### " "/etc/xray/sshx/listlock" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/sshx/listlock" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
pass=$(grep -E "^### " "/etc/xray/sshx/listlock" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
passwd -u $user &> /dev/null
echo -e "### $Login $exp $Pass" >> /etc/xray/ssh
sed -i "/^### $user $exp $pass/d" /etc/xray/sshx/listlock &> /dev/null
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  SSH DESBLOQUEADO </b>
<code>◇━━━━━━━━━━━━━━◇
<b>DOMINIO   :</b> <code>${domain} </code>
<b>IP        :</b> <code>$ISP $CITY </code>
<b>USUARIO   :</b> <code>$user </code>
<b>IP LIMIT  :</b> <code>$iplim IP </code>
<b>EXPIRA    :</b> <code>$exp </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Desbloqueo exitoso de cuenta...</i>
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
msg -bar
msg -tit
msg -bar
amacen " • CUENTA SSH DESBLOQUEADO •"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " Nombre del cliente : $user"
dnxaz " Estado Desbloqueado"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}

function banner(){
clear
msg -bar
msg -tit
msg -bar
amacen " CAMBIAR BANNER SSH "
msg -bar

echo -e "\033[1mPegue el contenido del banner personalizado a continuación (presione Ctrl+D para finalizar):\033[0m"
echo -e "\033[1m ⚠️ Pueda que sea necesario oprimir 2 veces Ctrl+D ⚠️):\033[0m"
custom_banner=$(</dev/stdin)

# Backup the original /etc/issue.net file
sudo cp /etc/issue.net /etc/issue.net.bak

# Write the custom banner to /etc/issue.net
echo "$custom_banner" | sudo tee /etc/issue.net > /dev/null

# Inform the user that the banner has been changed
echo ""
echo ""
echo "🚀 BANNER AGREGADO CON EXITO:🚀"
red " Por favor espera un segundo"
echo ""
service ssh restart 2>/dev/null
      service dropbear restart 2>/dev/null
echo "Presiona Enter para regresar al menú..."
read -r  # Espera a que el usuario presione Enter

read -n 1 -s -r -p "$(echo -e "\e[1;37;42mPRESIONE CUALQUIER TECLA PARA REGRESAR\e[0m")"
m-sshovpn
}

clear
author=$(cat /etc/profil)
msg -bar
msg -tit
msg -bar
amacen " CONFIGURACION SSH CLIENTES "
msg -bar
menu_func "NUEVO CLIENTE SSH 👤 " \
"USUARIO TEMPORAL SSH " \
"$(msg -verd "EDITAR RENOVAR CLIENTE") " \
"⚠️ ELIMINAR CLIENTE ⚠️\n$(msg -bar2)" \
"$(dnxver "VER CLIENTES CONECTADOS ") " \
"CONFIGURACION SE USUARIOS" \
" $(msg -ama "CAMBIAR LIMITE DE IP USER")\n$(msg -bar2)" \
"AUTO ELIMINAR O BLOQUEAR" \
" $(msg -verm2 "DESBLOQUEAR LOGIN SSH") \n$(msg -bar2)" \
"LISTA DE USUARIOS SSH CREADOS" \
"MODIFICAR BANNER SSH" \
#"CAMBIAR A MODO SSH/TOKEN"
back
echo -e ""
sres
echo -e ""

	selection=$(selection_fun 15)
	case ${selection} in
		0)menu;;
		1)usernew;;
		2)trial;;
		3)renew;;
		4)hapus;;
		5)cek;;
		6)cekconfig;;
		7)limitssh;;
		8)listssh;;
		9)lockssh;;
		10)liser;;
		11)banner;;
                #12)liser;;
    15)USER_MODE && break;;
    *) menu ;;
	esac
