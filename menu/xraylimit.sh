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
vmhas2=$(cat /tmp/vm | grep -w "${vmuser}" | cut -d ' ' -f 2-8 | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done )
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
    # Verificar si existe el archivo de última detección
    if [[ ! -f /etc/vmess/${vmuser}_last_detection ]]; then
        echo "$now" > /etc/vmess/${vmuser}_last_detection
    fi

    # Verificar si existe el archivo de contador de avisos
    if [[ ! -f /etc/vmess/${vmuser}_warnings ]]; then
        echo "0" > /etc/vmess/${vmuser}_warnings
    fi

    last_detection=$(cat /etc/vmess/${vmuser}_last_detection)
    warnings=$(cat /etc/vmess/${vmuser}_warnings)
    time_diff=$((now - last_detection))

    # Si han pasado al menos 5 minutos (300 segundos), proceder con la detección
    if [[ $time_diff -ge 300 ]]; then
        echo "$now" > /etc/vmess/${vmuser}_last_detection
        warnings=$((warnings + 1))
        echo "$warnings" > /etc/vmess/${vmuser}_warnings

        byt=$(cat /etc/limit/vmess/$vmuser)
        gb=$(convert ${byt})

        # Enviar aviso según el número de advertencias
        if [[ $warnings -le 3 ]]; then
            TEXT="
<b>⚠️ VMESS MULTI-LOGIN ADVERTENCIA ⚠️</b>
<code>──────────────────────</code>
<b>🌐 DOMINIO:</b> <code>${domen}</code>
<b>📍 IP:</b> <code>${ISP}</code>
<b>🌍 CIUDAD:</b> <code>${CITY}</code>
<b>📅 FECHA LOGIN:</b> <code>$DATE</code>
<b>👤 USUARIO:</b> <code>$vmuser</code>
<b>🔢 TOTAL LOGIN IP:</b> <code>${vmhas}</code>
<b>📊 USO DE DATOS:</b> <code>${gb}</code>
<code>──────────────────────</code>
<b>⏰ HORARIO DE LOGINS:</b>
<code>$vmhas2</code>
<code>──────────────────────</code>
<i>❗️ ${warnings}/3 Advertencias enviadas. 
Límite permitido: ${ssvmess}x.</i>
<i>⚠️ Próxima acción: Bloqueo automático.</i>
"
            curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
        fi

        # Eliminar al usuario un minuto después de la tercera advertencia
        if [[ $warnings -eq 3 ]]; then
            TEXT2="
<b>🚨 VMESS MULTI-LOGIN DETECTADO 🚨</b>
<code>──────────────────────</code>
<b>🌐 DOMINIO:</b> <code>${domen}</code>
<b>📍 IP:</b> <code>${ISP}</code>
<b>🌍 PAÍS:</b> <code>${CITY}</code>
<b>📅 FECHA LOGIN:</b> <code>$DATE</code>
<b>👤 USUARIO:</b> <code>$vmuser</code>
<b>🔢 TOTAL LOGIN IP:</b> <code>${vmhas}</code>
<b>📊 USO DE DATOS:</b> <code>${gb}</code>
<code>──────────────────────</code>
<b>⏰ HORARIO DE LOGINS:</b>
<code>$vmhas2</code>
<code>──────────────────────</code>
<i>🚫 ${ssvmess}x Multi-Login detectado. 
Cuenta será eliminada en 1 minuto...</i>
"
            curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null

            # Esperar 60 segundos antes de eliminar al usuario
            sleep 60

            # Eliminar al usuario
            exp=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
            uuid=$(grep -wE "^#vmg $vmuser" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
            echo "### $vmuser $exp $uuid" >> /etc/vmess/listlock
            sed -i "/^#vmg $vmuser $exp/,/^},{/d" /etc/xray/config.json
            sed -i "/^#vm $vmuser $exp/,/^},{/d" /etc/xray/config.json
            rm /etc/vmess/${vmuser}_warnings >/dev/null 2>&1
            systemctl restart xray
        fi
    fi
fi
done
fi
}
vmess
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
trip2=$(cat /tmp/tr | grep -w "${usrtr}" | cut -d ' ' -f 2-8 | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done )
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
if [ $trojanip = $sstrojan ]; then
echo -ne
if [ $type = "delete" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO : ${domen} </b>
<b>IP : ${ISP}</b>
<b>PAIS : ${CITY}</b>
<b>FECHA LOGIN : $DATE</b>
<b>USUARIO : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USADO : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIEMPO LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${sstrojan}x Multi Login Auto Bloqueo Activado ✅...</i>
"
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
fi
if [ $type = "lock" ]; then
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO : ${domen} </b>
<b>IP : ${ISP}</b>
<b>PAIS : ${CITY}</b>
<b>FECHA LOGIN : $DATE</b>
<b>USUARIO : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USADO : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TOTAL LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${sstrojan}x Multi Login Bloqueo en $waktulock Minutos...</i>
"
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
fi
else
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b> ⚠️ TROJAN MULTI LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO : ${domen} </b>
<b>IP : ${ISP}</b>
<b>PAIS : ${CITY}</b>
<b>FECHA LOGIN : $DATE</b>
<b>USUARIO : $usrtr </b>
<b>TOTAL LOGIN IP : ${trip} </b>
<b>USADO : ${gb} </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ TIEMPO LOGIN : IP LOGIN </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>$trip2</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>${trojanip}x Multi Login ❌: ${sstrojan}x Multi Login Advertencia ⚠️...</i>
"
echo "" > /tmp/tr
sed -i "/${usrtr}/d" /var/log/xray/access.log
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
if [ $trojanip -gt $sstrojan ]; then
exptr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuidtr=$(grep -wE "^#tr $usrtr" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
echo "### $usrtr $exptr $uuidtr" >> /etc/trojan/listlock
sed -i "/^#tr $usrtr $exptr/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $usrtr $exptr/,/^},{/d" /etc/xray/config.json
rm /etc/trojan/${usrtr}login >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
fi
fi
done
fi
}
vmess
vless
trojan
