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

ipsaya=$(curl -sS ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')


domain=$(cat /etc/xray/domain)
#color
grenbo="\e[92;1m"
NC='\e[0m'
WH='\033[1;37m'
#install
function install-bot(){
apt update -y && apt upgrade -y
apt install python3 python3-pip git speedtest-cli -y
sudo apt-get install -y p7zip-full
cd /usr/bin
clear
wget https://raw.githubusercontent.com/darnix1/vip/main/menu/bot.zip
unzip bot.zip
mv bot/* /usr/bin
chmod +x /usr/bin/*
rm -rf bot.zip
clear
wget https://raw.githubusercontent.com/darnix1/vip/main/menu/kyt.zip
unzip kyt.zip
pip3 install -r kyt/requirements.txt
clear
cd /usr/bin/kyt/bot
chmod +x *
mv -f * /usr/bin
rm -rf /usr/bin/kyt/bot
rm -rf /usr/bin/*.zip
cd
rm -rf /etc/tele

clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                ${WH}• BOT PANEL •                  ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "${grenbo}Tutorial Crear Bot and ID Telegram${NC}"
echo -e "${grenbo}[*] Crear Bot y Token Bot : @BotFather${NC}"
echo -e "${grenbo}[*] Info Id Telegram : @MissRose_bot , dominio /info${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
rm -rf /usr/bin/ddsdswl.session
rm -rf /usr/bin/kyt/var.txt
rm -rf /usr/bin/kyt/database.db
echo -e ""
read -e -p "[*] Ingrese su token de bot : " bottoken
read -e -p "[*] Ingrese su ID Telegram :" admin

cat >/usr/bin/kyt/var.txt <<EOF
BOT_TOKEN="$bottoken"
ADMIN="$admin"
DOMAIN="$domain"
EOF

echo 'TEXT=$'"(cat /etc/notiftele)"'' > /etc/tele
echo "TIMES=10" >> /etc/tele
echo 'KEY=$'"(cat /etc/per/token)"'' >> /etc/tele

echo "$bottoken" > /etc/per/token
echo "$admin" > /etc/per/id
echo "$bottoken" > /usr/bin/token
echo "$admin" > /usr/bin/idchat
echo "$bottoken" > /etc/perlogin/token
echo "$admin" > /etc/perlogin/id
clear

echo "SHELL=/bin/sh" >/etc/cron.d/cekbot
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>/etc/cron.d/cekbot
echo "*/1 * * * * root /usr/bin/cekbot" >>/etc/cron.d/cekbot

cat > /usr/bin/cekbot << END
nginx=$( systemctl status kyt | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    echo -ne
else
    systemctl restart kyt
    systemctl start kyt
fi

kyt=$( systemctl status kyt | grep "TERM" | wc -l )
if [[ $kyt == "0" ]]; then
echo -ne
else
    systemctl restart kyt
    systemctl start kyt
fi
END

cat > /etc/systemd/system/kyt.service << END
[Unit]
Description=Simple kyt - @kyt
After=syslog.target network-online.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m kyt
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload &> /dev/null
systemctl enable kyt &> /dev/null
systemctl start kyt &> /dev/null
systemctl restart kyt &> /dev/null

echo "Done"
echo " Instalaciones completas, escribe /start en tu bot"
read -n 1 -s -r -p "Presione cualquier tecla para regresar al menú"
menu
}
cd
if [ -e /usr/bin/kyt ]; then
echo -ne
else
install-bot
fi

#isi data
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ \033[1;37mPlease select a your Choice              $COLOR1│${NC}"
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌──────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│  [ 1 ]  \033[1;37mCAMBIAR LA BOT       ${NC}"
echo -e "$COLOR1│  "                                        
echo -e "$COLOR1│  [ 2 ]  \033[1;37mACTUALIZAR BOT     ${NC}"
echo -e "$COLOR1│  "                                        
echo -e "$COLOR1│  [ 3 ]  \033[1;37mELIMINAR BOT     ${NC}"
echo -e "$COLOR1│  "                                        
echo -e "$COLOR1│  [ 4 ]  \033[1;37mCAMBIAR NOMBRE DE LLAMADA DEL BOT (SERVIDOR MÚLTIPLE)     ${NC}"
echo -e "$COLOR1│  "                                        
echo -e "$COLOR1│  [ 5 ]  \033[1;37mAÑADIR ADMINISTRADOR     ${NC}"
echo -e "$COLOR1│  "                                        
echo -e "$COLOR1└──────────────────────────────────────────┘${NC}"
until [[ $domain2 =~ ^[1-5]+$ ]]; do 
read -p "   Por favor seleccione los números 1 al 5 : " domain2
done

if [[ $domain2 == "1" ]]; then
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                ${WH}• BOT PANEL •                  ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "${grenbo}Tutorial Creat Bot and ID Telegram${NC}"
echo -e "${grenbo}[*] Crear Bot and Token Bot : @BotFather${NC}"
echo -e "${grenbo}[*] Info Id Telegram : @MissRose_bot , perintah /info${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
rm -rf /usr/bin/ddsdswl.session
rm -rf /usr/bin/kyt/var.txt
rm -rf /usr/bin/kyt/database.db
echo -e ""
read -e -p "[*] Ingrese su token de bot : " bottoken
read -e -p "[*] Ingrese su Id Telegram :" admin

cat >/usr/bin/kyt/var.txt <<EOF
BOT_TOKEN="$bottoken"
ADMIN="$admin"
DOMAIN="$domain"
EOF

echo "$bottoken" > /etc/per/token
echo "$admin" > /etc/per/id
clear

cat > /etc/systemd/system/kyt.service << END
[Unit]
Description=Simple kyt - @kyt
After=syslog.target network-online.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m kyt
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload &> /dev/null
systemctl stop kyt &> /dev/null
systemctl enable kyt &> /dev/null
systemctl start kyt &> /dev/null
systemctl restart kyt &> /dev/null

echo "Done"
echo " Instalaciones completas, escribe /menu en tu bot"
read -n 1 -s -r -p "Presione cualquier tecla para regresar al menú"
menu
fi
if [[ $domain2 == "2" ]]; then
clear
cp -r /usr/bin/kyt/var.txt /usr/bin &> /dev/null
rm -rf /usr/bin/kyt.zip
rm -rf /usr/bin/kyt
sleep 2
cd /usr/bin
wget https://raw.githubusercontent.com/darnix1/vip/main/menu/bot.zip
unzip bot.zip
mv bot/* /usr/bin
chmod +x /usr/bin/*
rm -rf bot.zip
clear
wget https://raw.githubusercontent.com/darnix1/vip/main/menu/kyt.zip
unzip kyt.zip
pip3 install -r kyt/requirements.txt
clear
cd /usr/bin/kyt/bot
chmod +x *
mv -f * /usr/bin
rm -rf /usr/bin/kyt/bot
rm -rf /usr/bin/*.zip
mv /usr/bin/var.txt /usr/bin/kyt
cd
clear

systemctl daemon-reload &> /dev/null
systemctl stop kyt &> /dev/null
systemctl enable kyt &> /dev/null
systemctl start kyt &> /dev/null
systemctl restart kyt &> /dev/null
clear
echo -e "Actualización exitosa de BOT Telegram"
read -n 1 -s -r -p "Presione cualquier tecla para regresar al menú"
menu
fi

if [[ $domain2 == "3" ]]; then
clear
rm -rf /usr/bin/kyt
echo -e "Eliminación exitosa de BOT Telegram"
read -n 1 -s -r -p "Presione cualquier tecla para regresar al menú"
menu
fi

if [[ $domain2 == "4" ]]; then
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                ${WH}• BOT PANEL •                  ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "${grenbo}Esto se usa si quieres usar solo 1 bot sin necesitarlo. ${NC}"
echo -e "${grenbo}Muchos de estos bots de creación se utilizan para crear cuentas. ${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -e -p "[*] Ingrese el apodo del bot : " namabot

sed -i "s/77/${namabot}/g" /usr/bin/kyt/modules/menu.py
sed -i "s/77/${namabot}/g" /usr/bin/kyt/modules/start.py
sed -i "s/"sshovpn"/"sshovpn${namabot}"/g" /usr/bin/kyt/modules/menu.py
sed -i "s/"vmess"/"vmess${namabot}"/g" /usr/bin/kyt/modules/menu.py
sed -i "s/"vless"/"vless${namabot}"/g" /usr/bin/kyt/modules/menu.py
sed -i "s/"trojan"/"trojan${namabot}"/g" /usr/bin/kyt/modules/menu.py
sed -i "s&.menu|/menu&.${namabot}|/${namabot}&g" /usr/bin/kyt/modules/menu.py
sed -i "s&.start|/start&.start${namabot}|/start${namabot}&g" /usr/bin/kyt/modules/start.py
sed -i "s&.admin|/admin&.admin${namabot}|/admin${namabot}&g" /usr/bin/kyt/modules/admin.py
sed -i "s/b'start'/b'start${namabot}'/g" /usr/bin/kyt/modules/start.py
sed -i "s/b'admin'/b'admin${namabot}'/g" /usr/bin/kyt/modules/admin.py
sed -i "s/b'menu'/b'${namabot}'/g" /usr/bin/kyt/modules/menu.py
sed -i "s/b'menu'/b'${namabot}'/g" /usr/bin/kyt/modules/start.py
sed -i "s/add-ip/add-ip${namabot}/g" /usr/bin/kyt/modules/admin.py
sed -i "s/change-ip/change-ip${namabot}/g" /usr/bin/kyt/modules/admin.py
sed -i "s/add-key/add-key${namabot}/g" /usr/bin/kyt/modules/admin.py
sed -i "s/7-/${namabot}-/g" /usr/bin/kyt/modules/vmess.py
sed -i "s/b'vmess'/b'vmess${namabot}'/g" /usr/bin/kyt/modules/vmess.py
sed -i "s/7-/${namabot}-/g" /usr/bin/kyt/modules/vless.py
sed -i "s/b'vless'/b'vless${namabot}'/g" /usr/bin/kyt/modules/vless.py
sed -i "s/7-/${namabot}-/g" /usr/bin/kyt/modules/trojan.py
sed -i "s/b'trojan'/b'trojan${namabot}'/g" /usr/bin/kyt/modules/trojan.py
sed -i "s/7-/${namabot}-/g" /usr/bin/kyt/modules/ssh.py
sed -i "s/b'sshovpn'/b'sshovpn${namabot}'/g" /usr/bin/kyt/modules/ssh.py
sed -i "s/"menu"/"${namabot}"/g" /usr/bin/kyt/modules/vmess.py
sed -i "s/"menu"/"${namabot}"/g" /usr/bin/kyt/modules/vless.py
sed -i "s/"menu"/"${namabot}"/g" /usr/bin/kyt/modules/trojan.py
sed -i "s/"menu"/"${namabot}"/g" /usr/bin/kyt/modules/ssh.py
sed -i "s/"menu"/"${namabot}"/g" /usr/bin/kyt/modules/menu.py

clear
echo -e "Éxito al cambiar el apodo del BOT de Telegram"
echo -e "Si desea llamar al menú del bot, toque .${namabot} atau /${namabot}"
echo -e "Si desea llamar al bot de inicio, escriba .start${namabot} atau /start${namabot}"
systemctl restart kyt
read -n 1 -s -r -p "Presione cualquier tecla para regresar al menú"
menu
fi


if [[ $domain2 == "5" ]]; then
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                ${WH}• BOT PANEL •                  ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -e -p "[*] Ingrese el usuario ejemplo @darnix0 : " user
userke=$(cat /usr/bin/kyt/var.txt | wc -l)
sed -i '/(ADMIN,))/a hello	c.execute("INSERT INTO admin (user_id) VALUES (?)",(USER'""$userke""',))' /usr/bin/kyt/__init__.py
cat >>/usr/bin/kyt/var.txt <<EOF
USER${userke}="$user"
EOF
sed -i "s/hello//g" /usr/bin/kyt/__init__.py

echo 'curl -s --max-time $TIMES -d "chat_id='""$user""'&disable_web_page_preview=1&text=$TEXT&parse_mode=html" https://api.telegram.org/bot$KEY/sendMessage >/dev/null' >> /etc/tele
clear
echo -e "Succes TAMBAH Admin BOT Telegram"
rm -rf /usr/bin/ddsdswl.session
rm -rf /usr/bin/kyt/database.db
systemctl restart kyt 
read -n 1 -s -r -p "Presione cualquier tecla para regresar al menú"
menu
fi
