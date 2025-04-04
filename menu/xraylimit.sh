#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
ipsaya=$(wget -qO- ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/darnix1/permission/main/ip"

# Configuración de advertencias
WARNING_INTERVAL=300 # 5 minutos en segundos
MAX_WARNINGS=3

# Función para formatear notificaciones
function format_notification() {
    local protocol=$1
    local user=$2
    local logins=$3
    local usage=$4
    local login_details=$5
    local status=$6
    local warning_count=$7
    
    # Iconos según el protocolo
    case $protocol in
        "VMESS") icon="🛡️" ;;
        "VLESS") icon="🔒" ;;
        "TROJAN") icon="🐴" ;;
        *) icon="⚠️" ;;
    esac
    
    # Color según la gravedad
    if [[ $warning_count -lt $MAX_WARNINGS ]]; then
        color="🟠"
    else
        color="🔴"
    fi
    
    TEXT="
${color}━━━━━━━━━━━━━━━━━━━━━━━━${color}
${icon} <b>DETECCIÓN DE MÚLTIPLES LOGINS</b> ${icon}
<b>Protocolo:</b> $protocol
<b>Usuario:</b> <code>$user</code>
${color}━━━━━━━━━━━━━━━━━━━━━━━━${color}
<b>🌐 Información del Servidor</b>
├─ Dominio: <code>$domen</code>
├─ IP: $ISP
└─ Ubicación: $CITY

<b>📅 Fecha:</b> $DATE $TIME
<b>🔢 Logins detectados:</b> $logins
<b>📊 Consumo:</b> $usage
<b>⚠️ Advertencia:</b> $warning_count/$MAX_WARNINGS
${color}━━━━━━━━━━━━━━━━━━━━━━━━${color}
<b>🖥️ Detalle de Conexiones</b>
$login_details
${color}━━━━━━━━━━━━━━━━━━━━━━━━${color}
<b>📢 Estado:</b> $status
${color}━━━━━━━━━━━━━━━━━━━━━━━━${color}
<i>Notificación generada automáticamente</i>
"
    echo "$TEXT"
}

# Función para manejar advertencias
function handle_warning() {
    local protocol=$1
    local user=$2
    local logins=$3
    local usage=$4
    local login_details=$5
    local warning_count=$6
    
    # Crear directorio de advertencias si no existe
    mkdir -p "/etc/warnings/$protocol"
    
    # Registrar la advertencia
    echo "$(date +%s)" > "/etc/warnings/$protocol/$user"
    
    if [[ $warning_count -eq 1 ]]; then
        status="🔔 Primera advertencia - Multi Login Detectado"
    elif [[ $warning_count -eq 2 ]]; then
        status="⚠️ Segunda advertencia - Multi Login Persistente"
    else
        status="🛑 Tercera advertencia - Acción tomada"
    fi
    
    TEXT=$(format_notification "$protocol" "$user" "$logins" "$usage" "$login_details" "$status" "$warning_count")
    
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}

# Función para verificar advertencias previas
function check_warnings() {
    local protocol=$1
    local user=$2
    
    mkdir -p "/etc/warnings/$protocol"
    warning_file="/etc/warnings/$protocol/$user"
    
    if [[ -f "$warning_file" ]]; then
        last_warning=$(cat "$warning_file")
        current_time=$(date +%s)
        time_diff=$((current_time - last_warning))
        
        if [[ $time_diff -lt $WARNING_INTERVAL ]]; then
            echo "wait"
            return
        fi
        
        # Contar advertencias previas
        warning_count=$(($(cat "$warning_file" | wc -l) + 1))
        echo $warning_count
    else
        echo 1
    fi
}

#checking_sc
cd
bash2=$( pgrep bash | wc -l )
if [[ $bash2 -gt "20" ]]; then
killall bash
fi
inaIP=$(wget -qO- ipv4.icanhazip.com)
timenow=$(date +%T" WIB")
TIMES="10"
CHATID=$(cat /etc/perlogin/id)
KEY=$(cat /etc/perlogin/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"
domen=`cat /etc/xray/domain`
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M:%S')
author=$(cat /etc/profil)
type=$(cat /etc/typexray)
waktulock=$(cat /etc/waktulock)
if [[ -z ${waktulock} ]]; then
echo "15" > /etc/waktulock
fi
if [[ -z ${type} ]]; then
echo "delete" > /etc/typexray
fi

# Resto de las funciones originales (tim2sec, convert) se mantienen igual...

function vmess() {
cd
if [[ ! -e /etc/limit/vmess ]]; then
mkdir -p /etc/limit/vmess
fi
vm=($(cat /etc/xray/config.json | grep "^#vmg" | awk '{print $2}' | sort -u))
echo -n >/tmp/vm
for db1 in ${vm[@]}; do
logvm=$(cat /var/log/xray/access.log | grep -w "email: ${db1}" | tail -n 150)
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
vmhas2=$(cat /tmp/vm | grep -w "${vmuser}" | cut -d ' ' -f 2-8 | nl -s '. ' | sed 's/^/├─ /')
vmsde=$(ls "/etc/vmess" | grep -w "${vmuser}IP")
if [[ -z ${vmsde} ]]; then
vmip="0"
else
vmip=$(cat /etc/vmess/${vmuser}IP)
fi
if [[ ${vmhas} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${vmuser}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/vmess/${vmuser} ]; then
echo "${downlink}" > /etc/limit/vmess/${vmuser}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vmuser}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/vmess/${vmuser})
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/vmess/${vmuser}
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/vmess/${vmuser}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vmuser}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
if [ ! -e /etc/vmess/${vmuser} ]; then
echo "999999999999" > /etc/vmess/${vmuser}
fi
limit=$(cat /etc/vmess/${vmuser})
usage=$(cat /etc/limit/vmess/${vmuser})
if [ $usage -gt $limit ]; then
exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vmuser $exp $uuid" >> /etc/vmess/userQuota
sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
rm /etc/limit/vmess/${vmuser} >/dev/null 2>&1
systemctl restart xray
fi
fi
if [[ ${vmhas} -gt $vmip ]]; then
byt=$(cat /etc/limit/vmess/$vmuser)
gb=$(convert ${byt})
echo "$vmuser ${vmhas}" >> /etc/vmess/${vmuser}login
vmessip=$(cat /etc/vmess/${vmuser}login | wc -l)
ssvmess1=$(ls "/etc/vmess" | grep -w "notif")
if [[ -z ${ssvmess1} ]]; then
ssvmess="3"
else
ssvmess=$(cat /etc/vmess/notif)
fi

# Sistema de advertencias escalonadas
warning_count=$(check_warnings "vmess" "$vmuser")
if [[ $warning_count == "wait" ]]; then
    continue
fi

if [[ $warning_count -lt $MAX_WARNINGS ]]; then
    handle_warning "VMESS" "$vmuser" "$vmhas" "$gb" "$vmhas2" "$warning_count"
    continue
fi

# Si llegamos aquí, es la tercera advertencia - tomar acción
if [ $type = "lock" ]; then
    status="🛑 ${ssvmess}x Multi Login - Cuenta bloqueada temporalmente"
    action="⏳ Bloqueo por $waktulock minutos"
    TEXT2=$(format_notification "VMESS" "$vmuser" "$vmhas" "$gb" "$vmhas2" "$status" "$MAX_WARNINGS")

    echo "" > /tmp/vm
    sed -i "/${vmuser}/d" /var/log/xray/access.log
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
    echo "### $vmuser $exp $uuid" >> /etc/vmess/listlock
    sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
    sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
    rm /etc/vmess/${vmuser}login >/dev/null 2>&1
    cat> /etc/cron.d/vmess${vmuser} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray vmess $vmuser $uuid $exp
EOF
    systemctl restart xray
    service cron restart
    rm -f "/etc/warnings/vmess/$vmuser"
fi
if [ $type = "delete" ]; then
    status="🛑 ${ssvmess}x Multi Login - Cuenta eliminada"
    action="❌ Eliminación permanente"
    TEXT2=$(format_notification "VMESS" "$vmuser" "$vmhas" "$gb" "$vmhas2" "$status" "$MAX_WARNINGS")

    echo "" > /tmp/vm
    sed -i "/${vmuser}/d" /var/log/xray/access.log
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
    echo "### $vmuser $exp $uuid" >> /etc/vmess/listlock
    sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
    sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
    rm /etc/vmess/${vmuser}login >/dev/null 2>&1
    systemctl restart xray
    rm -f "/etc/warnings/vmess/$vmuser"
fi
done
fi
}

# Las funciones vless() y trojan() deben modificarse de manera similar a vmess()
# Implementando el mismo sistema de advertencias escalonadas

function vless() {
cd
if [[ ! -e /etc/limit/vless ]]; then
mkdir -p /etc/limit/vless
fi
vldat=($(cat /etc/xray/config.json | grep "^#vlg" | awk '{print $2}' | sort -u))
echo -n >/tmp/vl
for db2 in ${vldat[@]}; do
logvl=$(cat /var/log/xray/access.log | grep -w "email: ${db2}" | tail -n 150)
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
cat /tmp/vl | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/vl
spll=$(cat /tmp/vl)
fi
fi
fi
done <<<"${logvl}"
done
if [[ ${spll} != "" ]]; then
for vlus in ${vldat[@]}; do
vlsss=$(cat /tmp/vl | grep -w "${vlus}" | wc -l)
vlsss2=$(cat /tmp/vl | grep -w "${vlus}" | cut -d ' ' -f 2-8 | nl -s '. ' | sed 's/^/├─ /')
sdf=$(ls "/etc/vless" | grep -w "${vlus}IP")
if [[ -z ${sdf} ]]; then
vmip="0"
else
vmip=$(cat /etc/vless/${vlus}IP)
fi
if [[ ${vlsss} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${vlus}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/vless/${vlus} ]; then
echo "${downlink}" > /etc/limit/vless/${vlus}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vlus}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/vless/${vlus})
cd
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/vless/${vlus}
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/vless/${vlus}
xray api stats --server=127.0.0.1:10085 -name "user>>>${vlus}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
cd
if [ ! -e /etc/vless/${vlus} ]; then
echo "999999999999" > /etc/vless/${vlus}
fi
limit=$(cat /etc/vless/${vlus})
usage=$(cat /etc/limit/vless/${vlus})
if [ $usage -gt $limit ]; then
expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $vlus $expvl $uuidvl" >> /etc/vless/userQuota
sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
rm /etc/limit/vless/${vlus} >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
if [[ ${vlsss} -gt $vmip ]]; then
byt=$(cat /etc/limit/vless/$vlus)
gb=$(convert ${byt})
echo "$vlus ${vlsss}" >> /etc/vless/${vlus}login
vlessip=$(cat /etc/vless/${vlus}login | wc -l)
ssvless1=$(ls "/etc/vless" | grep -w "notif")
if [[ -z ${ssvless1} ]]; then
ssvless="3"
else
ssvless=$(cat /etc/vless/notif)
fi

# Sistema de advertencias escalonadas
warning_count=$(check_warnings "vless" "$vlus")
if [[ $warning_count == "wait" ]]; then
    continue
fi

if [[ $warning_count -lt $MAX_WARNINGS ]]; then
    handle_warning "VLESS" "$vlus" "$vlsss" "$gb" "$vlsss2" "$warning_count"
    continue
fi

# Tercera advertencia - tomar acción
if [ $type = "delete" ]; then
    status="🛑 ${ssvless}x Multi Login - Cuenta eliminada"
    TEXT2=$(format_notification "VLESS" "$vlus" "$vlsss" "$gb" "$vlsss2" "$status" "$MAX_WARNINGS")

    echo "" > /tmp/vl
    sed -i "/${vlus}/d" /var/log/xray/access.log
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
    echo "### $vlus $expvl $uuidvl" >> /etc/vless/listlock
    sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
    sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
    rm /etc/vless/${vlus}login >/dev/null 2>&1
    systemctl restart xray >/dev/null 2>&1
    rm -f "/etc/warnings/vless/$vlus"
fi
if [ $type = "lock" ]; then
    status="🛑 ${ssvless}x Multi Login - Cuenta bloqueada temporalmente"
    TEXT2=$(format_notification "VLESS" "$vlus" "$vlsss" "$gb" "$vlsss2" "$status" "$MAX_WARNINGS")

    echo "" > /tmp/vl
    sed -i "/${vlus}/d" /var/log/xray/access.log
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    expvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    uuidvl=$(grep -wE "^#vl $vlus" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
    echo "### $vlus $expvl $uuidvl" >> /etc/vless/listlock
    sed -i "/^#vl $vlus $expvl/,/^},{/d" /etc/xray/config.json
    sed -i "/^#vlg $vlus $expvl/,/^},{/d" /etc/xray/config.json
    rm /etc/vless/${vlus}login >/dev/null 2>&1
    cat> /etc/cron.d/vless${vlus} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray vless $vlus $uuidvl $expvl
EOF
    systemctl restart xray
    service cron restart
    rm -f "/etc/warnings/vless/$vlus"
fi
done
fi
}

function trojan() {
cd
if [[ ! -e /etc/limit/trojan ]]; then
mkdir -p /etc/limit/trojan
fi
trda=($(cat /etc/xray/config.json | grep "^#trg" | awk '{print $2}' | sort -u))
echo -n >/tmp/tr
for db3 in ${trda[@]}; do
logtr=$(cat /var/log/xray/access.log | grep -w "email: ${db3}" | tail -n 150)
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
cat /tmp/tr | grep -w "${ina}" | grep -w "${enu}" >/dev/null
if [[ $? -eq 1 ]]; then
echo "${ina} ${inu} WIB : ${enu}" >>/tmp/tr
restr=$(cat /tmp/tr)
fi
fi
fi
done <<<"${logtr}"
done
if [[ ${restr} != "" ]]; then
for usrtr in ${trda[@]}; do
trip=$(cat /tmp/tr | grep -w "${usrtr}" | wc -l)
trip2=$(cat /tmp/tr | grep -w "${usrtr}" | cut -d ' ' -f 2-8 | nl -s '. ' | sed 's/^/├─ /')
sdf=$(ls "/etc/trojan" | grep -w "${usrtr}IP")
if [[ -z ${sdf} ]]; then
sadsde="0"
else
sadsde=$(cat /etc/trojan/${usrtr}IP)
fi
if [[ ${trip} -gt "0" ]]; then
downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
cd
if [ ! -e /etc/limit/trojan/$usrtr ]; then
echo "${downlink}" > /etc/limit/trojan/${usrtr}
xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" -reset > /dev/null 2>&1
else
plus2=$(cat /etc/limit/trojan/$usrtr)
if [[ -z ${plus2} ]]; then
echo "1" > /etc/limit/trojan/$usrtr
fi
plus3=$(( ${downlink} + ${plus2} ))
echo "${plus3}" > /etc/limit/trojan/${usrtr}
xray api stats --server=127.0.0.1:10085 -name "user>>>${usrtr}>>>traffic>>>downlink" -reset > /dev/null 2>&1
fi
if [ ! -e /etc/trojan/${usrtr} ]; then
echo "999999999999" > /etc/trojan/${usrtr}
fi
limit=$(cat /etc/trojan/${usrtr})
usage=$(cat /etc/limit/trojan/${usrtr})
if [ $usage -gt $limit ]; then
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/userQuota
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/limit/trojan/${usrtr} >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
if [[ ${trip} -gt $sadsde ]]; then
byt=$(cat /etc/limit/trojan/$usrtr)
gb=$(convert ${byt})
echo "$usrtr ${trip}" >> /etc/trojan/${usrtr}login
trojanip=$(cat /etc/trojan/${usrtr}login | wc -l)
sstrojan1=$(ls "/etc/trojan" | grep -w "notif")
if [[ -z ${sstrojan1} ]]; then
sstrojan="3"
else
sstrojan=$(cat /etc/trojan/notif)
fi

# Sistema de advertencias escalonadas
warning_count=$(check_warnings "trojan" "$usrtr")
if [[ $warning_count == "wait" ]]; then
    continue
fi

if [[ $warning_count -lt $MAX_WARNINGS ]]; then
    handle_warning "TROJAN" "$usrtr" "$trip" "$gb" "$trip2" "$warning_count"
    continue
fi

# Tercera advertencia - tomar acción
if [ $type = "delete" ]; then
    status="🛑 ${sstrojan}x Multi Login - Cuenta eliminada"
    TEXT2=$(format_notification "TROJAN" "$usrtr" "$trip" "$gb" "$trip2" "$status" "$MAX_WARNINGS")

    echo "" > /tmp/tr
    sed -i "/${usrtr}/d" /var/log/xray/access.log
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
    echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/listlock
    sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
    sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
    rm /etc/trojan/${usrtr}login >/dev/null 2>&1
    systemctl restart xray >/dev/null 2>&1
    rm -f "/etc/warnings/trojan/$usrtr"
fi
if [ $type = "lock" ]; then
    status="🛑 ${sstrojan}x Multi Login - Cuenta bloqueada temporalmente"
    TEXT2=$(format_notification "TROJAN" "$usrtr" "$trip" "$gb" "$trip2" "$status" "$MAX_WARNINGS")

    echo "" > /tmp/tr
    sed -i "/${usrtr}/d" /var/log/xray/access.log
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
    echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/listlock
    sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
    sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
    rm /etc/trojan/${usrtr}login >/dev/null 2>&1
    cat> /etc/cron.d/trojan${usrtr} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray trojan $usrtr $uuidtr $exptr
EOF
    systemctl restart xray
    service cron restart
    rm -f "/etc/warnings/trojan/$usrtr"
fi
done
fi
}

vmess
vless
trojan
