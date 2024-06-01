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


#Termina Metodo
###############################################$$$


biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
MYIP=$(wget -qO- ifconfig.me)
colornow=$(cat /etc/rmbl/theme/color.conf)
export NC="\e[0m"
export yl='\033[0;33m';
export RED="\033[0;31m"
export COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
DATE2=$(date -R | cut -d " " -f -5)
MYIP=$(wget -qO- ifconfig.me)
Isadmin=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $5}')
Exp2=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $3}')
export RED='\033[0;31m'
export GREEN='\033[0;32m'
Name=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $2}')
ipsaya=$(wget -qO- ifconfig.me)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/darnix1/vip/main/izin"

function key(){
rm -rf /root/rmbl
echo -e  "${COLOR1}┌──────────────────────────────────────────┐${NC}"
echo -e  "${COLOR1}│              PASWORD SCRIPT RMBL VPN     │${NC}"
echo -e  "${COLOR1}└──────────────────────────────────────────┘${NC}"
echo " "
read -rp "Masukan Key Kamu Disini ctrl + c Exit : " -e kode
cd
if [ -z $kode ]; then
echo -e "KODE SALAH SILAHKAN MASUKKAN ULANG KODENYA"
key
fi
clear
LIST=$(curl -sS https://raw.githubusercontent.com/RMBL-VPN/license/main/key | grep $kode | awk '{print $2}')
Key=$(curl -sS https://raw.githubusercontent.com/RMBL-VPN/license/main/key | grep $kode | awk '{print $3}')
KEY2=$(curl -sS https://raw.githubusercontent.com/RMBL-VPN/license/main/key | grep $kode | awk '{print $4}')
ADMIN=$(curl -sS https://raw.githubusercontent.com/RMBL-VPN/license/main/key | grep $kode | awk '{print $5}')
TOTALIP=$(curl -sS https://raw.githubusercontent.com/RMBL-VPN/license/main/key | grep $kode | awk '{print $6}')
U2=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $2}')
U3=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $3}')
U4=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $4}')
U5=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $5}')
U6=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $6}')
MYIP=$(curl -sS ipv4.icanhazip.com)
web=$(curl -sS  http://rmb.vip.app/ress | grep $kode | awk '{print $3}')
web2=$(curl -sS http://rmb.vip.app/ress | grep $kode | awk '{print $2}')
web3=$(curl -sS http://rmb.vip.app/ress | grep $kode | awk '{print $4}')
web4=$(curl -sS http://rmb.vip.app/ress | grep $kode | awk '{print $5}')
web5=$(curl -sS http://rmb.vip.app/ress | grep $kode | awk '{print $6}')
userscript=$(curl -sS https://pastebin.com/raw/YZFr8JDy | awk '{print $1}')
emailscript=$(curl -sS https://pastebin.com/raw/YZFr8JDy | awk '{print $2}')
tokenscript=$(curl -sS https://pastebin.com/raw/YZFr8JDy | awk '{print $3}')
userkey=$(curl -sS https://pastebin.com/raw/unGxyHYK | awk '{print $1}')
emailkey=$(curl -sS https://pastebin.com/raw/unGxyHYK | awk '{print $2}')
tokenkey=$(curl -sS https://pastebin.com/raw/unGxyHYK | awk '{print $3}')
if [[ $kode == $web ]]; then
MYIP=$(curl -sS ipv4.icanhazip.com)
hhari=$(date -d "$web3 days" +"%Y-%m-%d")
mkdir /root/rmbl
cd /root/rmbl
wget https://raw.githubusercontent.com/darnix1/vip/main/izin >/dev/null 2>&1
if [ "$U4" = "$MYIP" ]; then
sed -i "s/### $U2 $U3 $U4 $U5/### $U2 $hhari $U4 $U5/g" /root/rmbl/ipmini
else
echo "### $author $hhari $MYIP $web2" >> ipmini
fi
sleep 0.5
rm -rf .git
git config --global user.email "${emailscript}" >/dev/null 2>&1
git config --global user.name "${userscript}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${userscript}/permission >/dev/null 2>&1
git push -f https://${tokenscript}@github.com/${userscript}/permission >/dev/null 2>&1
rm -rf /root/rmbl
rm -rf /etc/github
clear
elif [[ $kode == $Key ]]; then
MYIP=$(curl -sS ipv4.icanhazip.com)
author4=$(cat /etc/profil)
hhari=$(date -d "$KEY2 days" +"%Y-%m-%d")
mkdir /root/casper
cd /root/casper
wget https://raw.githubusercontent.com/darnix1/vip/main/izin >/dev/null 2>&1
if [ "$U4" = "$MYIP" ]; then
sed -i "s/### $U2 $U3 $U4 $U5/### $U2 $hhari $U4 $U5/g" /root/rmbl/ipmini
else
echo "### $author $hhari $MYIP $LIST" >> ipmini
fi
sleep 0.5
rm -rf .git
git config --global user.email "${emailscript}" >/dev/null 2>&1
git config --global user.name "${userscript}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add ipmini
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${userscript}/permission >/dev/null 2>&1
git push -f https://${tokenscript}@github.com/${userscript}/permission >/dev/null 2>&1
sleep 0.5
rm ipmini
wget https://raw.githubusercontent.com/RMBL-VPN/license/main/key >/dev/null 2>&1
if [ "$ADMIN" = "ON" ]; then
sed -i "/^### $LIST $Key $KEY2 $ADMIN $TOTALIP/d" /root/rmbl/key
else
sed -i "/^### $LIST $Key $KEY2/d" /root/rmbl/key
fi
sleep 0.5
rm -rf .git
git config --global user.email "${emailkey}" >/dev/null 2>&1
git config --global user.name "${userkey}" >/dev/null 2>&1
git init >/dev/null 2>&1
git add key
git commit -m register >/dev/null 2>&1
git branch -M main >/dev/null 2>&1
git remote add origin https://github.com/${userkey}/license >/dev/null 2>&1
git push -f https://${tokenkey}@github.com/${userkey}/license >/dev/null 2>&1
rm -rf /root/rmbl
rm -rf /etc/github
else
echo -e "KODE SALAH SILAHKAN MASUKKAN ULANG KODENYA"
sleep 1
key
fi
echo -e  "${COLOR1}┌──────────────────────────────────────────┐${NC}"
echo -e  "${COLOR1}│              INFO LICENSE KEY            │${NC}"
echo -e  "${COLOR1}└──────────────────────────────────────────┘${NC}"
echo -e "SUCCES MASUKKAN KEY SILAHKAN DITUNGGU"
echo -e "2 MENIT AGAR SERVER KEREFRESH"
read -n 1 -s -r -p "Press any key to Exit"
systemctl restart xray
reboot
exit
clear
}
madmin=$(curl -sS https://raw.githubusercontent.com/darnix1/vip/main/izin | grep $MYIP | awk '{print $5}')
checking_sc
cd
if [ ! -e /etc/per/id ]; then
mkdir -p /etc/per
echo "" > /etc/per/id
echo "" > /etc/per/token
elif [ ! -e /etc/perlogin/id ]; then
mkdir -p /etc/perlogin
echo "" > /etc/perlogin/id
echo "" > /etc/perlogin/token
elif [ ! -e /usr/bin/id ]; then
echo "" > /usr/bin/idchat
echo "" > /usr/bin/token
fi
if [ ! -e /etc/xray/ssh ]; then
echo "" > /etc/xray/ssh
elif [ ! -e /etc/xray/sshx ]; then
mkdir -p /etc/xray/sshx
elif [ ! -e /etc/xray/sshx/listlock ]; then
echo "" > /etc/xray/sshx/listlock
elif [ ! -e /etc/vmess ]; then
mkdir -p /etc/vmess
elif [ ! -e /etc/vmess/listlock ]; then
echo "" > /etc/vmess/listlock
elif [ ! -e /etc/vless ]; then
mkdir -p /etc/vless
elif [ ! -e /etc/vless/listlock ]; then
echo "" > /etc/vless/listlock
elif [ ! -e /etc/trojan ]; then
mkdir -p /etc/trojan
elif [ ! -e /etc/trojan/listlock ]; then
echo "" > /etc/trojan/listlock
fi
clear
MODEL2=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
LOADCPU=$(printf '%-0.00001s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
CORE=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
vnstat_profile=$(vnstat | sed -n '3p' | awk '{print $1}' | grep -o '[^:]*')
vnstat -i ${vnstat_profile} >/etc/t1
bulan=$(date +%b)
tahun=$(date +%y)
ba=$(curl -s https://pastebin.com/raw/0gWiX6hE)
today=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
todayd=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
today_v=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $9}')
today_rx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $2}')
today_rxv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $3}')
today_tx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $5}')
today_txv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $6}')
if [ "$(grep -wc ${bulan} /etc/t1)" != '0' ]; then
bulan=$(date +%b)
month=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $9}')
month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $10}')
month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $3}')
month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $4}')
month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $6}')
month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $7}')
else
bulan2=$(date +%Y-%m)
month=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $8}')
month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $9}')
month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $2}')
month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $3}')
month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $5}')
month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $6}')
fi
if [ "$(grep -wc yesterday /etc/t1)" != '0' ]; then
yesterday=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $8}')
yesterday_v=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $9}')
yesterday_rx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $2}')
yesterday_rxv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $3}')
yesterday_tx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $5}')
yesterday_txv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $6}')
else
yesterday=NULL
yesterday_v=NULL
yesterday_rx=NULL
yesterday_rxv=NULL
yesterday_tx=NULL
yesterday_txv=NULL
fi
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
status_ws="${COLOR1}ON${NC}"
else
status_ws="${RED}OFF${NC}"
fi
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
status_nginx="${COLOR1}ON${NC}"
else
status_nginx="${RED}OFF${NC}"
systemctl start nginx
fi
if [[ -e /usr/bin/kyt ]]; then
nginx=$( systemctl status kyt | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
echo -ne
else
systemctl start kyt
fi
fi
rm -rf /etc/status
xray=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xray == "running" ]]; then
status_xray="${COLOR1}ON${NC}"
else
status_xray="${RED}OFF${NC}"
fi
# STATUS EXPIRED ACTIVE
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[4$below" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}(Registered)${Font_color_suffix}"
Error="${Green_font_prefix}${Font_color_suffix}${Red_font_prefix}[EXPIRED]${Font_color_suffix}"

today=$(date -d "0 days" +"%Y-%m-%d")
if [[ $today < $Exp2 ]]; then
    sts="${Info}"
else
    sts="${Error}"
fi
vmess=$(grep -c -E "^#vmg " "/etc/xray/config.json")
vless=$(grep -c -E "^#vlg " "/etc/xray/config.json")
trtls=$(grep -c -E "^#trg " "/etc/xray/config.json")
total_ssh=$(grep -c -E "^### " "/etc/xray/ssh")
function m-ip2(){
clear
cd
if [[ -e /etc/github/api ]]; then
m-ip
else
mkdir /etc/github
echo "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" > /etc/github/api
echo "vpnrmbl@gmail.com" > /etc/github/email
echo "RMBL-VPN" > /etc/github/username
m-ip
fi
}
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
if [ "$Isadmin" = "ON" ]; then
uis="${COLOR1}Premium ADMIN VIP$NC"
else
uis="${COLOR1}Premium Version$NC"
fi
function m-bot2(){
clear
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1  ${WH}Please select a Bot type below                 ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1  [ 1 ] ${WH}Buat/Edit BOT INFO Multi Login SSH, XRAY & TRANSAKSI   ${NC}"
echo -e ""
echo -e "$COLOR1  [ 2 ] ${WH}Buat/Edit BOT INFO Create User & Lain Lain    ${NC}"
echo -e ""
echo -e "$COLOR1  [ 3 ] ${WH}Buat/Edit BOT INFO Backup Telegram    ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
read -p "   Please select numbers 1-3 or Any Button(Random) to exit : " bot
echo ""
if [[ $bot == "1" ]]; then
clear
rm -rf /etc/perlogin
mkdir -p /etc/perlogin
cd /etc/perlogin
touch token
touch id
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Multi Login"
read -rp "Enter Token (Creat on @BotFather) : " -e token2
echo "$token2" > token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idat
echo "$idat" > id
sleep 1
m-bot2
fi
if [[ $bot == "2" ]]; then
clear
rm -rf /etc/per
mkdir -p /etc/per
cd /etc/per
touch token
touch id
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Akun Dan Lain Lain"
read -rp "Enter Token (Creat on @BotFather) : " -e token3
echo "$token3" > token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idat2
echo "$idat2" > id
sleep 1
m-bot2
fi
if [[ $bot == "3" ]]; then
clear
rm -rf /usr/bin/token
rm -rf /usr/bin/idchat
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Backup Telegram"
read -rp "Enter Token (Creat on @BotFather) : " -e token23
echo "$token23" > /usr/bin/token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idchat
echo "$idchat" > /usr/bin/idchat
sleep 1
m-bot2
fi
menu
}
clear
clear && clear && clear
clear;clear;clear
msg -bar
msg -tit
msg -bar
echo -e "\033[38;5;239m═════════════════\e[48;5;1m\e[38;5;230m  MENU AUTO  \e[0m\e[38;5;239m════════════════════"
echo -e "\033[1;37m  •  S.O         \033[1;32m$MODEL2 \033[1;31m. \033[1;33m"
echo -e "\033[1;37m  •  DOMINIO     \033[1;32m$(cat /etc/xray/domain) \033[1;31m. \033[1;33m"
echo -e "\033[1;37m  •  SERVIDOR    \033[1;32m$MYIP \033[1;31m. \033[1;33m"
echo -e "\033[1;37m  •  RAM USADO   \033[1;32m$tram / $uram MB \033[1;31m. \033[1;33m"
echo -e "\033[1;37m  •  AUTOR       \033[1;32m$author"
echo -e "\033[38;5;239m═════════════════\e[48;5;2m\e[38;5;22m   SERVICIOS   \e[0m\e[38;5;239m════════════════════"

#echo -e "  \033[1;97m[ SSHWS : ${status_ws} ] \033[1;97m [ XRAY : ${status_xray} ]\033[1;97m [ NGINX : ${status_nginx} ]" 
echo -e "  \033[1;97m[ SSHWS : ${status_ws} \033[1;97m] \033[1;97m[ XRAY : ${status_xray} \033[1;97m] \033[1;97m[ NGINX : ${status_nginx} \033[1;97m]"
akun1="SSHWS"
akun2="VMESS"
akun3="VLESS"
akun4="TROJAN"
akun5="SHDW"
akun01="$total_ssh"
akun02="$vmess"
akun03="$vless"
akun04="${trtls}"
akun05="$ssa"
garis="${grs}║"
echo -e "\033[38;5;239m══════════════\e[100m\e[97m  CONTROL DE REGISTRO  \e[0m\e[38;5;239m═══════════════"
echo -e "\033[1;97m  $akun1:\033[93m[\033[1;92m$akun01\033[93m]\033[1;97m  $akun2:\033[93m[\033[1;92m$akun02\033[93m]\033[1;97m  $akun3:\033[93m[\033[1;92m$akun03\033[93m]\033[1;97m  $akun4:\033[93m[\033[1;92m$akun04\033[93m]\033[1;97m"
echo -e "\e[38;5;239m════════════════════════════════════════════════════"
echo -e "$COLOR1╔════════════════════ • MENU • ════════════════════╗${NC}"
echo -ne "\e[1;93m  [\e[1;32m1\e[1;93m]\033[1;31m • \e[1;97mSSH OPENVPN" && echo -e "   \e[1;93m  [\e[1;32m7\e[1;93m]\033[1;31m • \e[1;97mNOTIBOT"
echo -ne "\e[1;93m  [\e[1;32m2\e[1;93m]\033[1;31m • \e[1;97mXRAY/VMESS"  && echo -e "    \e[1;93m  [\e[1;32m8\e[1;93m]\033[1;31m • \e[1;97mTEMAS"
echo -ne "\e[1;93m  [\e[1;32m3\e[1;93m]\033[1;31m • \e[1;97mXRAY/VLESS"  && echo -e "    \e[1;93m  [\e[1;32m9\e[1;93m]\033[1;31m • \e[1;97mUPDATE"
echo -ne "\e[1;93m  [\e[1;32m4\e[1;93m]\033[1;31m • \e[1;97mTROJAN"      && echo -e "        \e[1;93m  [\e[1;32m10\e[1;93m]\033[1;31m • \e[1;97mSISTEMA"
echo -ne "\e[1;93m  [\e[1;32m5\e[1;93m]\033[1;31m • \e[1;97mSERVICIOS" && echo -e "     \e[1;93m  [\e[1;32m11\e[1;93m]\033[1;31m • \e[1;97mBACKUP"
echo -ne "\e[1;93m  [\e[1;32m6\e[1;93m]\033[1;31m • \e[1;97mTELEGRAM BOT"&& echo -e "  \e[1;93m  [\e[1;32m12\e[1;93m]\033[1;31m • \e[1;97mREINICIAR"
echo -e "$COLOR1╚═══════════════════════════════════════════════════╝${NC}"

#read -p " Selecciona Una Opcion : " opt


if [ "$Isadmin" = "ON" ]; then
#echo -e "$COLOR1┌──────────────── • PANEL ADMIN VIP • ────────────┐${NC}"
#echo -e "$COLOR1│  ${WH}[${COLOR1}13${WH}]${NC} ${COLOR1}• ${WH}RESELLER IP ${WH}[${COLOR1}MENU${WH}] $COLOR1 $NC"
ressee="m-ip2"
bottt="m-bot"
#echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
else
ressee="menu"
bottt="menu"
fi
#echo -e "    $COLOR1╔═════════════════════════════════════════════════╗${NC}"
echo -e "    $COLOR1║$NC  ${WH}Total    $COLOR1║${NC}    ${WH}Hoy     ${WH}   Ayer     ${WH}     Mes         ${NC}"
echo -e "    $COLOR1║$NC ${WH}Bantwidth $COLOR1║${NC}  ${WH}$today_tx $today_txv   ${WH}$yesterday_tx $yesterday_txv   ${WH}$month_tx $month_txv$COLOR1${NC}"
#echo -e "    $COLOR1╚═════════════════════════════════════════════════╝${NC}"
serverV=$( curl -sS https://raw.githubusercontent.com/darnix1/Premium/main/versi)
myver="$(cat /opt/.ver)"

if [[ $serverV > $myver ]]; then
echo -e "$RED┌─────────────────────────────────────────────────┐${NC}"
echo -e "$RED $NC ${COLOR1}[100]${NC} • ACTUALIZA A LA VERSION $serverV" 
echo -e "$RED└─────────────────────────────────────────────────┘${NC}"
up2u="updatews"
else
up2u="menu"
fi
DATE=$(date +'%Y-%m-%d')
datediff() {
d1=$(date -d "$1" +%s)
d2=$(date -d "$2" +%s)
echo -e "$COLOR1 $NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
function new(){
cat> /etc/cron.d/autocpu << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/3 * * * * root /usr/bin/autocpu
END
echo "Auto-Reboot CPU 100% TURN ON."
sleep 1
menu
}
function newx(){
clear
until [[ $usagee =~ ^[0-9]+$ ]]; do
read -p "kuota user format angka 1, 2 atau 3 (TERA): " usagee
done
echo "$usagee" > /etc/usagee
cat> /etc/cron.d/bantwidth << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/bin/bantwidth
END
echo "Auto-Shutdown $usagee TERA TURN ON."
sleep 1
menu
}
d1=$(date -d "$Exp2" +%s)
d2=$(date -d "$today" +%s)
certificate=$(( (d1 - d2) / 86400 ))
domain=$(cat /etc/xray/domain)
function bannner(){
wget -O /etc/issue.net "https://raw.githubusercontent.com/SatanTech/Premium/install/main/issue.net" &> /dev/null
echo "6531534912:AAEMmubeZLlXxRPt7tr5drirt2EHNCN3TF0" > /usr/bin/token
echo "6447416716" > /usr/bin/idchat
echo "6531534912:AAEMmubeZLlXxRPt7tr5drirt2EHNCN3TF0" > /etc/perlogin/token
echo "-1002097641597" > /etc/perlogin/id
echo "6531534912:AAEMmubeZLlXxRPt7tr5drirt2EHNCN3TF0" > /etc/per/token
echo "6447416716" > /etc/per/id
rm -rf /usr/bin/ddsdswl.session
rm -rf /usr/bin/kyt/var.txt
rm -rf /usr/bin/kyt/database.db
cat >/usr/bin/kyt/var.txt <<EOF
BOT_TOKEN="6531534912:AAEMmubeZLlXxRPt7tr5drirt2EHNCN3TF0"
ADMIN="6447416716"
DOMAIN="$domain"
EOF
systemctl restart nginx
systemctl restart ws-stunnel
systemctl restart kyt
echo "lock" > /etc/typessh
echo "lock" > /etc/typexray
menu
}
function updatews(){
cd
rm -rf *
wget https://raw.githubusercontent.com/darnix1/Premium/main/menu/m-update.sh &> /dev/null
chmod +x m-update.sh
./m-update.sh
}
#echo -e "         $COLOR1╔═════════════════════════════════════════╗${NC}"
#echo -e "         $COLOR1╚═════════════════════════════════════════╝${NC}"
echo -e ""
selection=$(selection_fun2 100)
case ${selection} in
1) m-sshovpn ;;
2) m-vmess ;;
3) m-vless ;;
4) m-trojan ;;
5) running ;;
6) m-bot ;;
7) m-bot2 ;;
8) m-theme ;;
9) m-update ;;
10) m-system ;;
11) m-backup ;;
12) reboot ;;
100) clear ; $up2u ;;
#14) remove_script ;;
0)
  cd $HOME && clear
  clear
  exit 0
  ;;
esac
