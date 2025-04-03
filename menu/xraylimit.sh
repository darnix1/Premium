/{vm,vl,tr}
#!/bin/bash

# Configuración básica
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'

# Información del servidor
ipsaya=$(wget -qO- ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
domen=$(cat /etc/xray/domain)
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
DATE=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M:%S')
timenow=$(date +%T" WIB")

# Configuración de Telegram
TIMES="10"
CHATID=$(cat /etc/perlogin/id)
KEY=$(cat /etc/perlogin/token)
URL="https://api.telegram.org/bot$KEY/sendMessage"

# Configuración de seguridad
bash2=$(pgrep bash | wc -l)
if [[ $bash2 -gt "20" ]]; then
    killall bash
fi

# Configuración de tipo de acción
author=$(cat /etc/profil)
type=$(cat /etc/typexray)
waktulock=$(cat /etc/waktulock)
if [[ -z ${waktulock} ]]; then
    echo "15" > /etc/waktulock
fi
if [[ -z ${type} ]]; then
    echo "delete" > /etc/typexray
fi

# Función para convertir tiempo a segundos
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

# Función para convertir bytes a formato legible
convert() {
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

# Función para obtener país de una IP
get_country() {
    local ip="$1"
    local country=$(curl -s "http://ip-api.com/json/${ip}?fields=country,isp" | jq -r '[.country, .isp] | join(" - ")')
    if [[ -z "$country" || "$country" = "null - null" ]]; then
        echo "Desconocido"
    else
        echo "$country"
    fi
}

# Función centralizada para notificaciones
send_notification() {
    local protocol="$1"
    local username="$2"
    local logins="$3"
    local usage="$4"
    local logins_list="$5"
    local action="$6"

    # Definir emoji según la acción
    case "$action" in
        *LOCK*) emoji="🔒" ;;
        *DELETE*) emoji="❌" ;;
        *WARNING*) emoji="⚠️" ;;
        *) emoji="ℹ️" ;;
    esac

    local message="
${emoji} <b>${protocol^^} MULTI LOGIN - ${action^^}</b> ${emoji}
━━━━━━━━━━━━━━━━
<b>🖥 SERVIDOR:</b>
├ Dominio: <code>${domen}</code>
├ IP: <code>${ipsaya}</code>
└ Ubicación: ${CITY} (${ISP})

<b>👤 USUARIO:</b> <code>${username}</code>
<b>📊 TRÁFICO USADO:</b> ${usage}
<b>🔢 LOGINS SIMULTÁNEOS:</b> ${logins}

<b>🌍 DETALLE DE CONEXIONES:</b>
${logins_list}
━━━━━━━━━━━━━━━━
<b>⏰ FECHA:</b> ${DATE} ${TIME}
<b>🚦 ACCIÓN:</b> ${action}
"

    # Enviar a Telegram
    curl -s --max-time "$TIMES" \
        -d "chat_id=$CHATID&text=$(echo "$message" | sed 's/\"/\\"/g')&parse_mode=html" \
        "$URL" >/dev/null

    # Registrar en log local
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${protocol} ${username} ${logins} ${action}" >> /var/log/xray/multi_login.log
}

# Función para procesar VMess
vmess() {
    mkdir -p /etc/limit/vmess
    vm_users=($(cat /etc/xray/config.json | grep "^#vmg" | awk '{print $2}' | sort -u))
    
    echo -n > /tmp/vm
    for user in "${vm_users[@]}"; do
        while read -r line; do
            if [[ -n "$line" ]]; then
                set -- $line
                ip="${7}"
                time_login="${2}"
                protocol="${3}"
                ip_short=$(echo "$protocol" | sed 's/tcp://g' | cut -d. -f1-3)
                
                now=$(tim2sec "$timenow")
                client_time=$(tim2sec "$time_login")
                diff_time=$((now - client_time))
                
                if [[ $diff_time -lt 40 ]]; then
                    if ! grep -q "$ip $ip_short" /tmp/vm; then
                        country=$(get_country "$ip")
                        echo "$user $ip ($country) $time_login WIB" >> /tmp/vm
                    fi
                fi
            fi
        done <<< "$(cat /var/log/xray/access.log | grep -w "email: $user" | tail -n 150)"
    done

    if [[ -s /tmp/vm ]]; then
        for user in "${vm_users[@]}"; do
            user_logins=$(grep -w "$user" /tmp/vm | wc -l)
            login_details=$(grep -w "$user" /tmp/vm | cut -d' ' -f2- | nl -s'. ' | while read line; do printf "├ %-20s\n" "$line"; done)
            
            # Obtener uso de datos
            downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
            [[ -z "$downlink" ]] && downlink=0
            
            # Administrar límites
            mkdir -p /etc/limit/vmess
            if [[ ! -f /etc/limit/vmess/$user ]]; then
                echo "$downlink" > /etc/limit/vmess/$user
            else
                prev_usage=$(cat /etc/limit/vmess/$user)
                total_usage=$((prev_usage + downlink))
                echo "$total_usage" > /etc/limit/vmess/$user
            fi
            xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1
            
            # Verificar límites
            user_limit=$(cat /etc/vmess/${user} 2>/dev/null || echo "999999999999")
            if [[ $total_usage -gt $user_limit ]]; then
                send_notification "VMESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "DELETE (Límite de datos)"
                # Resto de la lógica de eliminación...
            fi
            
            # Verificar múltiples logins
            max_logins=$(cat /etc/vmess/notif 2>/dev/null || echo "3")
            if [[ $user_logins -ge $max_logins ]]; then
                if [[ "$type" = "lock" ]]; then
                    send_notification "VMESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "LOCK ($waktulock mins)"
                    # Resto de la lógica de bloqueo...
                else
                    send_notification "VMESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "DELETE (Multi-Login)"
                    # Resto de la lógica de eliminación...
                fi
            elif [[ $user_logins -gt 1 ]]; then
                send_notification "VMESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "WARNING"
            fi
        done
    fi
}

# Funciones para VLESS y Trojan (estructura similar)
vless() {
    mkdir -p /etc/limit/vless
    vl_users=($(cat /etc/xray/config.json | grep "^#vlg" | awk '{print $2}' | sort -u))
    
    echo -n > /tmp/vl
    for user in "${vl_users[@]}"; do
        while read -r line; do
            if [[ -n "$line" ]]; then
                set -- $line
                ip="${7}"
                time_login="${2}"
                protocol="${3}"
                ip_short=$(echo "$protocol" | sed 's/tcp://g' | cut -d. -f1-3)
                
                now=$(tim2sec "$timenow")
                client_time=$(tim2sec "$time_login")
                diff_time=$((now - client_time))
                
                if [[ $diff_time -lt 40 ]]; then
                    if ! grep -q "$ip $ip_short" /tmp/vl; then
                        country=$(get_country "$ip")
                        echo "$user $ip ($country) $time_login WIB" >> /tmp/vl
                    fi
                fi
            fi
        done <<< "$(cat /var/log/xray/access.log | grep -w "email: $user" | tail -n 150)"
    done

    if [[ -s /tmp/vl ]]; then
        for user in "${vl_users[@]}"; do
            user_logins=$(grep -w "$user" /tmp/vl | wc -l)
            login_details=$(grep -w "$user" /tmp/vl | cut -d' ' -f2- | nl -s'. ' | while read line; do printf "├ %-20s\n" "$line"; done)
            
            # Obtener uso de datos
            downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
            [[ -z "$downlink" ]] && downlink=0
            
            # Administrar límites
            mkdir -p /etc/limit/vless
            if [[ ! -f /etc/limit/vless/$user ]]; then
                echo "$downlink" > /etc/limit/vless/$user
            else
                prev_usage=$(cat /etc/limit/vless/$user)
                total_usage=$((prev_usage + downlink))
                echo "$total_usage" > /etc/limit/vless/$user
            fi
            xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1
            
            # Verificar límites
            user_limit=$(cat /etc/vless/${user} 2>/dev/null || echo "999999999999")
            if [[ $total_usage -gt $user_limit ]]; then
                send_notification "VLESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "DELETE (Límite de datos)"
                expvl=$(grep -wE "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort -u)
                uuidvl=$(grep -wE "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort -u)
                echo "### $user $expvl $uuidvl" >> /etc/vless/listlock
                sed -i "/^#vlg $user $expvl/,/^},{/d" /etc/xray/config.json
                sed -i "/^#vl $user $expvl/,/^},{/d" /etc/xray/config.json
                rm /etc/limit/vless/${user} >/dev/null 2>&1
                systemctl restart xray >/dev/null 2>&1
            fi
            
            # Verificar múltiples logins
            max_logins=$(cat /etc/vless/notif 2>/dev/null || echo "3")
            if [[ $user_logins -ge $max_logins ]]; then
                if [[ "$type" = "lock" ]]; then
                    send_notification "VLESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "LOCK ($waktulock mins)"
                    expvl=$(grep -wE "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort -u)
                    uuidvl=$(grep -wE "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort -u)
                    echo "### $user $expvl $uuidvl" >> /etc/vless/listlock
                    sed -i "/^#vlg $user $expvl/,/^},{/d" /etc/xray/config.json
                    sed -i "/^#vl $user $expvl/,/^},{/d" /etc/xray/config.json
                    rm /etc/vless/${user}login >/dev/null 2>&1
                    cat> /etc/cron.d/vless${user} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray vless $user $uuidvl $expvl
EOF
                    systemctl restart xray
                    service cron restart
                else
                    send_notification "VLESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "DELETE (Multi-Login)"
                    expvl=$(grep -wE "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort -u)
                    uuidvl=$(grep -wE "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort -u)
                    echo "### $user $expvl $uuidvl" >> /etc/vless/listlock
                    sed -i "/^#vlg $user $expvl/,/^},{/d" /etc/xray/config.json
                    sed -i "/^#vl $user $expvl/,/^},{/d" /etc/xray/config.json
                    rm /etc/vless/${user}login >/dev/null 2>&1
                    systemctl restart xray >/dev/null 2>&1
                fi
            elif [[ $user_logins -gt 1 ]]; then
                send_notification "VLESS" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "WARNING"
            fi
        done
    fi
}

trojan() {
    mkdir -p /etc/limit/trojan
    tr_users=($(cat /etc/xray/config.json | grep "^#trg" | awk '{print $2}' | sort -u))
    
    echo -n > /tmp/tr
    for user in "${tr_users[@]}"; do
        while read -r line; do
            if [[ -n "$line" ]]; then
                set -- $line
                ip="${7}"
                time_login="${2}"
                protocol="${3}"
                ip_short=$(echo "$protocol" | sed 's/tcp://g' | cut -d. -f1-3)
                
                now=$(tim2sec "$timenow")
                client_time=$(tim2sec "$time_login")
                diff_time=$((now - client_time))
                
                if [[ $diff_time -lt 40 ]]; then
                    if ! grep -q "$ip $ip_short" /tmp/tr; then
                        country=$(get_country "$ip")
                        echo "$user $ip ($country) $time_login WIB" >> /tmp/tr
                    fi
                fi
            fi
        done <<< "$(cat /var/log/xray/access.log | grep -w "email: $user" | tail -n 150)"
    done

    if [[ -s /tmp/tr ]]; then
        for user in "${tr_users[@]}"; do
            user_logins=$(grep -w "$user" /tmp/tr | wc -l)
            login_details=$(grep -w "$user" /tmp/tr | cut -d' ' -f2- | nl -s'. ' | while read line; do printf "├ %-20s\n" "$line"; done)
            
            # Obtener uso de datos
            downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2)
            [[ -z "$downlink" ]] && downlink=0
            
            # Administrar límites
            mkdir -p /etc/limit/trojan
            if [[ ! -f /etc/limit/trojan/$user ]]; then
                echo "$downlink" > /etc/limit/trojan/$user
            else
                prev_usage=$(cat /etc/limit/trojan/$user)
                total_usage=$((prev_usage + downlink))
                echo "$total_usage" > /etc/limit/trojan/$user
            fi
            xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1
            
            # Verificar límites
            user_limit=$(cat /etc/trojan/${user} 2>/dev/null || echo "999999999999")
            if [[ $total_usage -gt $user_limit ]]; then
                send_notification "TROJAN" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "DELETE (Límite de datos)"
                exptr=$(grep -wE "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort -u)
                uuidtr=$(grep -wE "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort -u)
                echo "### $user $exptr $uuidtr" >> /etc/trojan/listlock
                sed -i "/^#trg $user $exptr/,/^},{/d" /etc/xray/config.json
                sed -i "/^#tr $user $exptr/,/^},{/d" /etc/xray/config.json
                rm /etc/limit/trojan/${user} >/dev/null 2>&1
                systemctl restart xray >/dev/null 2>&1
            fi
            
            # Verificar múltiples logins
            max_logins=$(cat /etc/trojan/notif 2>/dev/null || echo "3")
            if [[ $user_logins -ge $max_logins ]]; then
                if [[ "$type" = "lock" ]]; then
                    send_notification "TROJAN" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "LOCK ($waktulock mins)"
                    exptr=$(grep -wE "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort -u)
                    uuidtr=$(grep -wE "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort -u)
                    echo "### $user $exptr $uuidtr" >> /etc/trojan/listlock
                    sed -i "/^#trg $user $exptr/,/^},{/d" /etc/xray/config.json
                    sed -i "/^#tr $user $exptr/,/^},{/d" /etc/xray/config.json
                    rm /etc/trojan/${user}login >/dev/null 2>&1
                    cat> /etc/cron.d/trojan${user} << EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray trojan $user $uuidtr $exptr
EOF
                    systemctl restart xray
                    service cron restart
                else
                    send_notification "TROJAN" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "DELETE (Multi-Login)"
                    exptr=$(grep -wE "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort -u)
                    uuidtr=$(grep -wE "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort -u)
                    echo "### $user $exptr $uuidtr" >> /etc/trojan/listlock
                    sed -i "/^#trg $user $exptr/,/^},{/d" /etc/xray/config.json
                    sed -i "/^#tr $user $exptr/,/^},{/d" /etc/xray/config.json
                    rm /etc/trojan/${user}login >/dev/null 2>&1
                    systemctl restart xray >/dev/null 2>&1
                fi
            elif [[ $user_logins -gt 1 ]]; then
                send_notification "TROJAN" "$user" "$user_logins" "$(convert $total_usage)" "$login_details" "WARNING"
            fi
        done
    fi
}

# Ejecutar las funciones en paralelo
vmess &
vless &
trojan &
wait

# Limpieza final
rm -f /tmp/vm /tmp/vl /tmp/tr
