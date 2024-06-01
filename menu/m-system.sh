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

function ins-helium(){
clear
if [[ -e /usr/bin/helium ]]; then
helium
else
echo -ne
if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
echo -e " OS UBUNTU GA BISA INSTALL MENU INI"
read -n 1 -s -r -p "  Press any key to Back"
menu
else
wget -q -O /usr/bin/helium "https://cdn.discordapp.com/attachments/1043809011474112566/1054014513428566016/helium.sh" && chmod +x /usr/bin/helium && helium
fi
fi
}
function add-host(){
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
echo -ne "  \033[0;33mUodate Domain... \033[1;37m- \033[0;33m["
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
sldns() {
wget https://raw.githubusercontent.com/RMBL-VPN/v/main/slowdns/installsl.sh && chmod +x installsl.sh && ./installsl.sh
}
res1() {
wget https://raw.githubusercontent.com/RMBL-VPN/v/main/slowdns/rmbl.sh && chmod +x rmbl.sh && ./rmbl.sh
clear
}
res2() {
wget https://raw.githubusercontent.com/RMBL-VPN/v/main/slowdns/rmbl1.sh && chmod +x rmbl1.sh && ./rmbl1.sh
clear
}
res3() {
wget https://raw.githubusercontent.com/RMBL-VPN/v/main/slowdns/rmbl2.sh && chmod +x rmbl2.sh && ./rmbl2.sh
clear
}
clear
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ ${WH}Please select a your Choice to Set Domain              ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  ${WH}Domain kamu Sendri    ${NC}"
echo -e "$COLOR1│"
echo -e "$COLOR1│  [ 2 ]  ${WH}Domain Yang Punya Script     ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $dns =~ ^[0-9]+$ ]]; do
read -p "   Please select numbers 1-2 or Any Button(Random) : " dns
done
if [[ $dns == "1" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}DARI SAYA                  $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dnss =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan domain kamu Disini : " -e dnss
done
echo ""
echo "$dnss" > /etc/xray/domain
echo "$dnss" > /etc/v2ray/domain
echo "IP=$dnss" > /var/lib/ipvps.conf
read -n 1 -s -r -p "  Press any key to Back Menu"
menu
clear
elif [[ $dns == "2" ]]; then
clear
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice to Set Domain$COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mDomain xxx.pirang.cloud       ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 2 ]  \033[1;37mDomain xxx.berurat.cloud     ${NC}"
echo -e "$COLOR1│  "
echo -e "$COLOR1│  [ 3 ]  \033[1;37mDomain xnxxms.cloud       ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $domain2 =~ ^[1-6]+$ ]]; do
read -p "   Please select numbers 1 sampai 3 : " domain2
done
if [[ $domain2 == "1" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│  \033[1;37mContoh subdomain xxx.pirang.cloud       $COLOR1│${NC}"
echo -e  "$COLOR1│    \033[1;37mxxx jadi subdomain kamu               $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn1 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn1
done
echo "$dn1" > /etc/xray/domain
echo "$dn1" > /root/subdomainx
cd
sleep 1
fun_bar 'res1'
clear
rm -rf /root/subdomainx
fi
if [[ $domain2 == "2" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│  \033[1;37mContoh subdomain xxx.berurat.cloud      $COLOR1│${NC}"
echo -e  "$COLOR1│    \033[1;37mxxx jadi subdomain kamu               $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn2 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn2
done
echo "$dn2" > /etc/xray/domain
echo "$dn2" > /root/subdomainx
cd
sleep 1
fun_bar 'res2'
clear
rm -rf /root/subdomainx
fi
if [[ $domain2 == "3" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│  \033[1;37mContoh subdomain xxx.xnxxms.cloud       $COLOR1│${NC}"
echo -e  "$COLOR1│    \033[1;37mxxx jadi subdomain kamu               $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn3 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn3
done
echo "$dn3" > /etc/xray/domain
echo "$dn3" > /root/subdomainx
cd
sleep 1
fun_bar 'res5'
clear
rm -rf /root/subdomainx
fi
if [[ $domain2 == "4" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│  \033[1;37mContoh subdomain xxx.slowapp.dev        $COLOR1│${NC}"
echo -e  "$COLOR1│    \033[1;37mxxx jadi subdomain kamu               $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn4 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn4
done
echo "$dn4" > /etc/xray/domain
echo "$dn4" > /root/subdomainx
cd
sleep 1
fun_bar 'res4'
clear
rm -rf /root/subdomainx
fi
if [[ $domain2 == "5" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│  \033[1;37mContoh subdomain xxx.vpnvip.tech        $COLOR1│${NC}"
echo -e  "$COLOR1│    \033[1;37mxxx jadi subdomain kamu               $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn5 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn5
done
echo "$dn5" > /etc/xray/domain
echo "$dn5" > /root/subdomainx
cd
sleep 1
fun_bar 'res3'
clear
rm -rf /root/subdomainx
fi
if [[ $domain2 == "6" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│  \033[1;37mContoh subdomain xxx.slowvip.tech        $COLOR1│${NC}"
echo -e  "$COLOR1│    \033[1;37mxxx jadi subdomain kamu               $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dn6 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan subdomain kamu Disini tanpa spasi : " -e dn6
done
echo "$dn6" > /etc/xray/domain
echo "$dn6" > /root/subdomainx
cd
sleep 1
fun_bar 'res6'
clear
rm -rf /root/subdomainx
fi
read -n 1 -s -r -p "  Press any key to Renew Cert or Ctrl + C to Exit"
certv2ray
clear
elif [[ $dns == "3" ]]; then
clear
cd
sleep 1
fun_bar 'sldns'
read -n 1 -s -r -p "  Press any key to Back Menu"
menu
clear
elif [[ $dns == "4" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}RMBL VPN                   $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dns1 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan domain kamu Disini : " -e dns1
done
echo ""
echo "$dns1" > /etc/xray/domain
echo "$dns1" > /etc/v2ray/domain
echo "IP=$dns1" > /var/lib/ipvps.conf
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}RMBL VPN                   $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dns2 =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan Domain SlowDNS kamu Disini : " -e dns2
done
echo $dns2 >/etc/xray/dns
read -n 1 -s -r -p "  Press any key to Back Menu"
menu
clear
elif [[ $dns == "5" ]]; then
clear
echo -e  "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e  "$COLOR1│             ${WH}TERIMA KASIH                 $COLOR1│${NC}"
echo -e  "$COLOR1│        ${WH}SUDAH MENGGUNAKAN SCRIPT          $COLOR1│${NC}"
echo -e  "$COLOR1│               ${WH}RMBL VPN                   $COLOR1│${NC}"
echo -e  "$COLOR1└──────────────────────────────────────────┘${NC}"
echo " "
until [[ $dnscl =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan domain kamu Disini : " -e dnscl
done
echo ""
echo "$dnscl" > /etc/cloudfront
fi
echo -e " Back To Menu"
sleep 1
menu
}
function auto-reboot(){
clear
if [ ! -e /etc/cron.d/re_otm ]; then
rm -rf /etc/cron.d/re_otm
fi
if [ ! -e /usr/local/bin/reboot_otomatis ]; then
echo '#!/bin/bash' > /usr/local/bin/reboot_otomatis
echo 'tanggal=$(date +"%m-%d-%Y")' >> /usr/local/bin/reboot_otomatis
echo 'waktu=$(date +"%T")' >> /usr/local/bin/reboot_otomatis
echo 'echo "Server successfully rebooted on the date of $tanggal hit $waktu." >> /etc/log-reboot.txt' >> /usr/local/bin/reboot_otomatis
echo '/sbin/shutdown -r now' >> /usr/local/bin/reboot_otomatis
chmod +x /usr/local/bin/reboot_otomatis
fi
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[0;100;33m       • AUTO-REBOOT MENU •        \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "[\e[36m•1\e[0m] Set Auto-Reboot Setiap 1 Jam"
echo -e "[\e[36m•2\e[0m] Set Auto-Reboot Setiap 6 Jam"
echo -e "[\e[36m•3\e[0m] Set Auto-Reboot Setiap 12 Jam"
echo -e "[\e[36m•4\e[0m] Set Auto-Reboot Setiap 1 Hari"
echo -e "[\e[36m•5\e[0m] Set Auto-Reboot Setiap 1 Minggu"
echo -e "[\e[36m•6\e[0m] Set Auto-Reboot Setiap 1 Bulan"
echo -e "[\e[36m•7\e[0m] Set Auto-Rebooot CPU 100%"
echo -e "[\e[36m•8\e[0m] Matikan Auto-Reboot & Auto-Reboot CPU 100%"
echo -e "[\e[36m•9\e[0m] View reboot log"
echo -e "[\e[36m•10\e[0m] Remove reboot log"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " x
if test $x -eq 1; then
echo "10 * * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been set every an hour."
sleep 2
menu
elif test $x -eq 2; then
echo "10 */6 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set every 6 hours."
sleep 2
menu
elif test $x -eq 3; then
echo "10 */12 * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set every 12 hours."
sleep 2
menu
elif test $x -eq 4; then
echo -e " CONTOH FORMAT Tiap jam 5 Subuh Tulis 5 "
read -p " Waktu Restart : " wkt
echo "0 $wkt * * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set once a day."
sleep 2
menu
elif test $x -eq 5; then
echo -e " CONTOH FORMAT Tiap jam 8 Malam Tulis 20 "
read -p " Waktu Restart : " wkt2
echo "10 $wkt2 */7 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set once a week."
sleep 2
menu
elif test $x -eq 6; then
echo -e " CONTOH FORMAT Tiap jam 10 Malam Tulis 20 "
read -p " Waktu Restart : " wkt3
echo "10 $wkt3 1 * * root /usr/local/bin/reboot_otomatis" > /etc/cron.d/reboot_otomatis
echo "Auto-Reboot has been successfully set once a month."
sleep 2
menu
elif test $x -eq 7; then
cat> /etc/cron.d/autocpu << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/7 * * * * root /usr/bin/autocpu
END
echo "Auto-Reboot CPU 100% TURN ON."
sleep 2
menu
elif test $x -eq 8; then
rm -f /etc/cron.d/reboot_otomatis
rm -f /etc/cron.d/autocpu
echo "Auto-Reboot successfully TURNED OFF."
sleep 2
menu
elif test $x -eq 9; then
if [ ! -e /etc/log-reboot.txt ]; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}       ${WH} • AUTO-REBOOT •        ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo "No reboot activity found"
echo -e ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
else
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}        ${WH}• AUTO-REBOOT •        ${NC} $COLOR1 $NC"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo 'LOG REBOOT'
cat /etc/log-reboot.txt
echo -e ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
fi
elif test $x -eq 10; then
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}        ${WH}• AUTO-REBOOT •        ${NC} $COLOR1 $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo "" > /etc/log-reboot.txt
echo "Auto Reboot Log successfully deleted!"
echo -e ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
elif test $x -eq 0; then
clear
menu
else
clear
echo ""
echo "Options Not Found In Menu"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
auto-reboot
fi
}
function bw(){
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}      • BANDWITH MONITOR •         ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -e " ${WH}[${COLOR1}•1${WH}]${NC} ${COLOR1} Lihat Total Bandwith Tersisa"
echo -e " ${WH}[${COLOR1}•2${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap 5 Menit"
echo -e " ${WH}[${COLOR1}•3${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Jam"
echo -e " ${WH}[${COLOR1}•4${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Hari"
echo -e " ${WH}[${COLOR1}•5${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Bulan"
echo -e " ${WH}[${COLOR1}•6${WH}]${NC} ${COLOR1} Tabel Penggunaan Setiap Tahun"
echo -e " ${WH}[${COLOR1}•7${WH}]${NC} ${COLOR1} Tabel Penggunaan Tertinggi"
echo -e " ${WH}[${COLOR1}•8${WH}]${NC} ${COLOR1} Statistik Penggunaan Setiap Jam"
echo -e " ${WH}[${COLOR1}•9${WH}]${NC} ${COLOR1} Lihat Penggunaan Aktif Saat Ini"
echo -e " ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1} Lihat Trafik Penggunaan Aktif Saat Ini [5s]"
echo -e ""
echo -e " [\e[31m•0${WH}]${NC} ${COLOR1} \e[31mBACK TO MENU${NC}"
echo -e " [\e[31m•x${WH}]${NC} ${COLOR1} Keluar"
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1} • TOTAL BANDWITH SERVER TERSISA • ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
2)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1} • TOTAL BANDWITH SETIAP 5 MENIT • ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -5
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
3)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}   • TOTAL BANDWITH SETIAP JAM •   ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -h
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
4)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}  • TOTAL BANDWITH SETIAP HARI •   ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -d
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
5)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}  • TOTAL BANDWITH SETIAP BULAN •  ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -m
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
6)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}  • TOTAL BANDWITH SETIAP TAHUN •  ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -y
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
7)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}    • TOTAL BANDWITH TERTINGGI •   ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -t
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
8)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1} • STATISTIK TERPAKAI SETIAP JAM • ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -hg
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
9)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}     • LIVE BANDWITH SAAT INI •    ${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e   " Press [ Ctrl+C ] • To-Exit"
echo -e ""
vnstat -l
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
10)
clear
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}• LIVE TRAFIK PENGGUNAAN BANDWITH •${NC} $COLOR1 $NC"
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
vnstat -tr
echo -e ""
echo -e "${COLOR1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;
0)
sleep 1
menu
;;
x)
exit
;;
*)
echo -e ""
echo -e "Anda salah tekan"
sleep 1
bw
;;
esac
}
function limitspeed(){
clear
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=$(cat /home/limit)
NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}');
function start () {
echo -e "Limit Speed All Service"
read -p "Set maximum download rate (in Kbps): " down
read -p "Set maximum upload rate (in Kbps): " up
if [[ -z "$down" ]] && [[ -z "$up" ]]; then
echo > /dev/null 2>&1
else
echo "Start Configuration"
sleep 0.5
wondershaper -a $NIC -d $down -u $up > /dev/null 2>&1
systemctl enable --now wondershaper.service
echo "start" > /home/limit
echo "Done"
fi
}
function stop () {
wondershaper -ca $NIC
systemctl stop wondershaper.service
echo "Stop Configuration"
sleep 0.5
echo > /home/limit
echo "Done"
}
if [[ "$cek" = "start" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "=================================="
echo -e "    Limit Bandwidth Speed $sts    "
echo -e "=================================="
echo -e "[1]. Start Limit"
echo -e "[2]. Stop Limit"
echo -e "==============================="
read -rp "Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
start
elif [[ "$num" = "2" ]]; then
stop
else
clear
echo " You Entered The Wrong Number"
menu
fi
}
function certv2ray(){
echo -e ""
echo start
sleep 0.5
source /var/lib/ipvps.conf
domain=$(cat /etc/xray/domain)
STOPWEBSERVER=$(lsof -i:89 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
rm -rf /root/.acme.sh
mkdir /root/.acme.sh
systemctl stop $STOPWEBSERVER
systemctl stop nginx
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --register-account -m rmbl@slowapp.cfd
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
chmod 777 /etc/xray/xray.key  
systemctl restart nginx
systemctl restart xray
menu
}
function clearcache(){
clear
echo ""
echo ""
echo -e "[ \033[32mInfo\033[0m ] Clear RAM Cache"
echo 1 > /proc/sys/vm/drop_caches
sleep 3
echo -e "[ \033[32mok\033[0m ] Cache cleared"
echo ""
echo "Back to menu in 2 sec "
sleep 2
menu
}
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
function m-webmin() {
clear
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Installed]${Font_color_suffix}"
Error="${Red_font_prefix}[Not Installed]${Font_color_suffix}"
cek=$(netstat -ntlp | grep 10000 | awk '{print $7}' | cut -d'/' -f2)
function install () {
IP=$(wget -qO- ifconfig.me/ip);
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m        • INSTALL WEBMIN •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.5
echo ""
echo -e "\033[32m[Info]\033[0m Adding Repository Webmin"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
apt install gnupg gnupg1 gnupg2 -y > /dev/null 2>&1
wget http://www.webmin.com/jcameron-key.asc > /dev/null 2>&1
apt-key add jcameron-key.asc > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Start Install Webmin"
sleep 0.5
apt update > /dev/null 2>&1
apt install webmin -y > /dev/null 2>&1
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
echo -e "\033[32m[Info]\033[0m Restart Webmin"
/etc/init.d/webmin restart > /dev/null 2>&1
rm -f /root/jcameron-key.asc > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Webmin Install Successfully !"
echo ""
echo " $IP:10000"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-webmin
}
function restart () {
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m        • RESTART WEBMIN •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.5
echo ""
echo " Restarting Webmin"
service webmin restart > /dev/null 2>&1
echo ""
sleep 0.5
echo -e "\033[32m[Info]\033[0m Webmin Start Successfully !"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-webmin
}
function uninstall () {
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m       • UNINSTALL WEBMIN •        \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.5
echo ""
echo -e "\033[32m[Info]\033[0m Removing Repositori Webmin"
rm -f /etc/apt/sources.list.d/webmin.list
apt update > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Start Uninstall Webmin"
apt autoremove --purge webmin -y > /dev/null 2>&1
sleep 0.5
echo -e "\033[32m[Info]\033[0m Webmin Uninstall Successfully !"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-webmin
}
if [[ "$cek" = "perl" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m          • WEBMIN MENU •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " Status $sts"
echo -e " [\e[36m•1\e[0m] Install Webmin"
echo -e " [\e[36m•2\e[0m] Restart Webmin"
echo -e " [\e[36m•3\e[0m] Uninstall Webmin"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -rp " Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
install
elif [[ "$num" = "2" ]]; then
restart
elif [[ "$num" = "3" ]]; then
uninstall
elif [[ "$num" = "0" ]]; then
menu
elif [[ "$num" = "x" ]]; then
exit
else
clear
echo " You Entered The Wrong Number"
sleep 2
m-webmin
fi
}
function speed(){
cd
if [[ -e /etc/speedi ]]; then
speedtest
else
sudo apt-get install curl
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
touch /etc/speedi
speedtest
fi
}
function gotopp(){
cd
if [[ -e /usr/bin/gotop ]]; then
gotop
else
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop &> /dev/null
/tmp/gotop/scripts/download.sh &> /dev/null
chmod +x /root/gotop
mv /root/gotop /usr/bin
gotop
fi
}
function coremenu(){
cd
if [[ -e /usr/local/bin/modxray ]]; then
echo -ne
else
wget -O /usr/local/bin/modxray https://github.com/dharak36/Xray-core/releases/download/v1.0.0/xray.linux.64bit &> /dev/null
fi
cd
if [[ -e /usr/local/bin/offixray ]]; then
echo -ne
else
cp -r /usr/local/bin/xray /usr/local/bin/offixray &> /dev/null
fi
clear
echo -e " "
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ ${WH}Please select a your Choice to Set CORE MENU           ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  ${WH}XRAY CORE OFFICIAL       ${NC}"
echo -e "$COLOR1│"
echo -e "$COLOR1│  [ 2 ]  ${WH}XRAY CORE MOD DHARAK    ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $core =~ ^[0-9]+$ ]]; do
read -p "   Please select numbers 1-2 or Any Button(EXIT) : " core
done
if [[ $core == "1" ]]; then
clear
echo -e " "
cp -r /usr/local/bin/offixray /usr/local/bin/xray &> /dev/null
chmod 755 /usr/local/bin/xray
systemctl restart xray
echo -e "$COLOR1 [ INFO ] ${WH}Succes Change Xray Core Official"
fi
if [[ $core == "2" ]]; then
clear
echo -e " "
cp -r /usr/local/bin/modxray /usr/local/bin/xray &> /dev/null
chmod 755 /usr/local/bin/xray
systemctl restart xray
echo -e  "$COLOR1 [ INFO ] ${WH}Succes Change Xray Core Mod Dharak"
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function dobot(){
clear
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ ${WH}Please select a your Choice to Set           ${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  ${WH}INSTAL BOT CRATE AKUN DIGITAL OCEAN      ${NC}"
echo -e "$COLOR1│"
echo -e "$COLOR1│  [ 2 ]  ${WH}COPY BOT CREATE AKUN DIGITAL OCEAN   ${NC}"
if [[ -e /etc/cron.d/bantwidth ]]; then
echo -ne
else
echo -e "$COLOR1│"
echo -e "$COLOR1│  [ 3 ]  ${WH}SET BANTWIDTH BUAT JUALAN DIGITAL OCEAN${NC}"
fi
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $dobot =~ ^[0-9]+$ ]]; do
read -p "   Please select numbers 1-3 or Any Button(BACK) : " dobot
done
if [[ $dobot == "1" ]]; then
clear
wget https://raw.githubusercontent.com/casper9/dobot/main/install.sh &> /dev/null
chmod +x install.sh
bash install.sh
rm -rf install.sh
fi
if [[ $dobot == "2" ]]; then
clear
if [[ -e /etc/dobot ]]; then
echo -ne
else
echo -e " SILAHKAN INSTALL DULU BOT CREATE AKUN DIGITAL OCEAN NYA"
read -n 1 -s -r -p "Press any key to back on menu"
m-system
fi
until [[ $dobot2 =~ ^[0-9]+$ ]]; do
read -p "   SILAHKAN TULIS COPY BOTNYA CONTOH 1 atau 3 : " dobot2
done
if [[ -e /etc/dobot${dobot2} ]]; then
echo -e "Angka Copyan Sudah ADA Silahkan tulis Angka yg lain"
read -n 1 -s -r -p "Press any key to back on menu"
m-system
fi
cp -r /etc/dobot /etc/dobot${dobot2}
read -e -p "[*] Input your Nama Store : " nama
read -e -p "[*] Input your Bot Token : " bottoken
read -e -p "[*] Input Your Id Telegram :" admin
rm -rf /etc/dobot${dobot2}/config.json
cat > /etc/dobot${dobot2}/config.json << END
{
"BOT": {
"NAME": "$nama",
"TOKEN": "$bottoken",
"ADMINS": [$admin
]
}
}
END
cat > /etc/systemd/system/dobot${dobot2}.service << END
[Unit]
Description=SGDO
After=network.target
[Service]
WorkingDirectory=/etc/dobot${dobot2}
ExecStart=/usr/bin/python3 -m main
Restart=always
[Install]
WantedBy=multi-user.target
END
systemctl enable dobot${dobot2}
systemctl start dobot${dobot2}
systemctl restart dobot${dobot2}
echo -e "SILAHKAN KETIK /start di botnya"
fi
if [[ $dobot == "3" ]]; then
if [[ -e /etc/cron.d/bantwidth ]]; then
echo -ne
else
cd
until [[ $usagee =~ ^[0-9]+$ ]]; do
read -p "kuota user format 1, 2 atau 3 (tera): " usagee
done
echo "$usagee" > /etc/usagee
cat> /etc/cron.d/bantwidth << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/bin/bantwidth
END
echo "Auto-Shutdown $usagee TERA TURN ON."
sleep 1
fi
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function speed2(){
apt install -y neofecth >/dev/null
clear
neofetch
speedtest
}
function nameauthor(){
read -rp "Input Your New Name : " -e name
echo "$name" > /etc/profil
read -n 1 -s -r -p " Succes Change Press Any key to Back Menu"
menu
}
clear
echo -e " $COLOR1╔══════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║${NC}${COLBG1}                 ${WH}• SYSTEM MENU •                      ${NC}$COLOR1║ $NC"
echo -e " $COLOR1╚══════════════════════════════════════════════════════╝${NC}"
echo -e " $COLOR1╔══════════════════════════════════════════════════════╗${NC}"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}CAMBIAR DOMINIO ${WH}    ${WH}[${COLOR1}09${WH}]${NC} ${COLOR1}• ${WH}CHANGE BANNER ${WH}     $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}SPEEDTEST   ${WH}        ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1}• ${WH}INSTALL ADBLOCK ${WH}   $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}AUTO REBOOT   ${WH}      ${WH}[${COLOR1}11${WH}]${NC} ${COLOR1}• ${WH}CHANGE  BOT INFO${WH}   $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}CHECK BANDWITH${WH}      ${WH}[${COLOR1}12${WH}]${NC} ${COLOR1}• ${WH}FIX NGINX OFF${WH}      $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}05${WH}]${NC} ${COLOR1}• ${WH}INSTALL WEBMIN${WH}      ${WH}[${COLOR1}13${WH}]${NC} ${COLOR1}• ${WH}RENDIMIENTO VPS${WH}  $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}06${WH}]${NC} ${COLOR1}• ${WH}INSTALL TCP BBR ${WH}    ${WH}[${COLOR1}14${WH}]${NC} ${COLOR1}• ${WH}CHANGE CORE MENU${WH}   $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}07${WH}]${NC} ${COLOR1}• ${WH}GANTI TEMA WARNA${WH}    ${WH}[${COLOR1}15${WH}]${NC} ${COLOR1}• ${WH}BOT DO MENU ${WH}       $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}08${WH}]${NC} ${COLOR1}• ${WH}LIMIT SPEED${WH}         ${WH}[${COLOR1}16${WH}]${NC} ${COLOR1}• ${WH}GANTI NAMA CLIENT${WH}  $COLOR1║ $NC"
echo -e " $COLOR1║${NC} ${WH}[${COLOR1}00${WH}]${NC} ${COLOR1}• ${WH}GO BACK $NC            ${WH}[${COLOR1}99${WH}]${NC} ${COLOR1}• ${WH}CLEAR RAM CACHE ${WH}   $COLOR1║ $NC"
echo -e " $COLOR1╚══════════════════════════════════════════════════════╝${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 |1) clear ; add-host ; exit ;;
02 |2) clear ; speed2 ; exit ;;
03 |3) clear ; auto-reboot ; exit ;;
04 |4) clear ; bw ; exit ;;
05 |5) clear ; m-webmin ; exit ;;
06 |6) clear ; m-tcp ; exit ;;
07 |7) clear ; m-theme ; exit ;;
08 |8) clear ; limitspeed ; exit ;;
09 |9) clear ; nano /etc/issue.net ; exit ;;
10 |10) clear ; ins-helium ;;
11 |11) clear ; m-bot2 ; exit ;;
12 |12) clear ; certv2ray ; exit ;;
13 |13) clear ; gotopp ; exit ;;
14 |14) clear ; coremenu ; exit ;;
15 |15) clear ; dobot ; exit ;;
16 |16) clear ; nameauthor ; exit ;;
99 |99) clear ; clearcache ; exit ;;
00 |0) clear ; menu ; exit ;;
*) echo -e "" ; echo "Anda salah tekan" ; sleep 1 ; m-system ;;
esac
