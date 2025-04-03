#!/bin/bash

# =============================================
# CONFIGURACIÓN BÁSICA DEL SCRIPT
# =============================================

# Variables de color
NC="\e[0m"
RED="\033[0;31m"
WH='\033[1;37m'

# Información del servidor
ipsaya=$(wget -qO- ipinfo.io/ip)
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
type=$(cat /etc/typexray || echo "delete")
waktulock=$(cat /etc/waktulock || echo "15")

# =============================================
# FUNCIONES AUXILIARES
# =============================================

# Convertir tiempo a segundos
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

# Convertir bytes a formato legible
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

# Obtener información geográfica de IP
get_country() {
    local ip="$1"
    local country=$(curl -s "http://ip-api.com/json/${ip}?fields=country,isp" | jq -r '[.country, .isp] | join(" - ")')
    [[ -z "$country" || "$country" = "null - null" ]] && echo "Desconocido" || echo "$country"
}

# Función central de notificaciones
send_notification() {
    local protocol="$1"
    local username="$2"
    local logins="$3"
    local usage="$4"
    local logins_list="$5"
    local action="$6"

    # Emojis según acción
    case "$action" in
        *LOCK*) emoji="🔒" ;;
        *DELETE*) emoji="❌" ;;
        *WARNING*) emoji="⚠️" ;;
        *) emoji="ℹ️" ;;
    esac

    local message="
${emoji} <b>${protocol^^} ALERTA - ${action^^}</b> ${emoji}
━━━━━━━━━━━━━━━━
<b>🖥 SERVIDOR:</b>
├ Dominio: <code>${domen}</code>
├ IP: <code>${ipsaya}</code>
└ Ubicación: ${CITY} (${ISP})

<b>👤 USUARIO:</b> <code>${username}</code>
<b>📊 TRÁFICO:</b> ${usage}
<b>🔢 LOGINS:</b> ${logins}

<b>🌍 CONEXIONES ACTIVAS:</b>
${logins_list}
━━━━━━━━━━━━━━━━
<b>⏰ FECHA:</b> ${DATE} ${TIME}
<b>🚦 ACCIÓN:</b> ${action}
"

    curl -s --max-time "$TIMES" \
        -d "chat_id=$CHATID&text=$(echo "$message" | sed 's/\"/\\"/g')&parse_mode=html" \
        "$URL" >/dev/null

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${protocol} ${username} ${logins} ${action}" >> /var/log/xray/multi_login.log
}

# =============================================
# FUNCIONES PRINCIPALES (VMESS, VLESS, TROJAN)
# =============================================

vmess() {
    mkdir -p /etc/limit/vmess
    local users=($(grep "^#vmg" /etc/xray/config.json | awk '{print $2}' | sort -u))
    
    echo -n > /tmp/vm
    for user in "${users[@]}"; do
        grep -w "email: $user" /var/log/xray/access.log | tail -n 150 | while read -r line; do
            [[ -z "$line" ]] && continue
            set -- $line
            ip="${7}"
            time_login="${2}"
            protocol="${3}"
            ip_short=$(echo "$protocol" | sed 's/tcp://g' | cut -d. -f1-3)
            
            now=$(tim2sec "$timenow")
            client_time=$(tim2sec "$time_login")
            (( now - client_time < 40 )) && \
            ! grep -q "$ip $ip_short" /tmp/vm && \
            echo "$user $ip ($(get_country "$ip")) $time_login WIB" >> /tmp/vm
        done
    done

    [[ -s /tmp/vm ]] || return

    for user in "${users[@]}"; do
        local logins=$(grep -w "$user" /tmp/vm | wc -l)
        local details=$(grep -w "$user" /tmp/vm | cut -d' ' -f2- | nl -s'. ' | while read line; do printf "├ %-20s\n" "$line"; done)
        
        # Manejo de tráfico
        local downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2 || echo "0")
        local total_usage=$(( $(cat /etc/limit/vmess/$user 2>/dev/null || echo "0") + downlink ))
        echo "$total_usage" > /etc/limit/vmess/$user
        xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1

        # Verificar límites
        local max_logins=$(cat /etc/vmess/notif 2>/dev/null || echo "3")
        local user_limit=$(cat /etc/vmess/$user 2>/dev/null || echo "999999999999")

        if (( total_usage > user_limit )); then
            send_notification "VMESS" "$user" "$logins" "$(convert $total_usage)" "$details" "DELETE (Límite de datos)"
            # Lógica de eliminación...
        elif (( logins >= max_logins )); then
            if [[ "$type" = "lock" ]]; then
                send_notification "VMESS" "$user" "$logins" "$(convert $total_usage)" "$details" "LOCK ($waktulock mins)"
                # Lógica de bloqueo...
            else
                send_notification "VMESS" "$user" "$logins" "$(convert $total_usage)" "$details" "DELETE (Multi-Login)"
                # Lógica de eliminación...
            fi
        elif (( logins > 1 )); then
            send_notification "VMESS" "$user" "$logins" "$(convert $total_usage)" "$details" "WARNING"
        fi
    done
}

vless() {
    mkdir -p /etc/limit/vless
    local users=($(grep "^#vlg" /etc/xray/config.json | awk '{print $2}' | sort -u))
    
    echo -n > /tmp/vl
    for user in "${users[@]}"; do
        grep -w "email: $user" /var/log/xray/access.log | tail -n 150 | while read -r line; do
            [[ -z "$line" ]] && continue
            set -- $line
            ip="${7}"
            time_login="${2}"
            protocol="${3}"
            ip_short=$(echo "$protocol" | sed 's/tcp://g' | cut -d. -f1-3)
            
            now=$(tim2sec "$timenow")
            client_time=$(tim2sec "$time_login")
            (( now - client_time < 40 )) && \
            ! grep -q "$ip $ip_short" /tmp/vl && \
            echo "$user $ip ($(get_country "$ip")) $time_login WIB" >> /tmp/vl
        done
    done

    [[ -s /tmp/vl ]] || return

    for user in "${users[@]}"; do
        local logins=$(grep -w "$user" /tmp/vl | wc -l)
        local details=$(grep -w "$user" /tmp/vl | cut -d' ' -f2- | nl -s'. ' | while read line; do printf "├ %-20s\n" "$line"; done)
        
        # Manejo de tráfico
        local downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2 || echo "0")
        local total_usage=$(( $(cat /etc/limit/vless/$user 2>/dev/null || echo "0") + downlink ))
        echo "$total_usage" > /etc/limit/vless/$user
        xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1

        # Verificar límites
        local max_logins=$(cat /etc/vless/notif 2>/dev/null || echo "3")
        local user_limit=$(cat /etc/vless/$user 2>/dev/null || echo "999999999999")

        if (( total_usage > user_limit )); then
            send_notification "VLESS" "$user" "$logins" "$(convert $total_usage)" "$details" "DELETE (Límite de datos)"
            # Lógica de eliminación...
        elif (( logins >= max_logins )); then
            if [[ "$type" = "lock" ]]; then
                send_notification "VLESS" "$user" "$logins" "$(convert $total_usage)" "$details" "LOCK ($waktulock mins)"
                # Lógica de bloqueo...
            else
                send_notification "VLESS" "$user" "$logins" "$(convert $total_usage)" "$details" "DELETE (Multi-Login)"
                # Lógica de eliminación...
            fi
        elif (( logins > 1 )); then
            send_notification "VLESS" "$user" "$logins" "$(convert $total_usage)" "$details" "WARNING"
        fi
    done
}

trojan() {
    mkdir -p /etc/limit/trojan
    local users=($(grep "^#trg" /etc/xray/config.json | awk '{print $2}' | sort -u))
    
    echo -n > /tmp/tr
    for user in "${users[@]}"; do
        grep -w "email: $user" /var/log/xray/access.log | tail -n 150 | while read -r line; do
            [[ -z "$line" ]] && continue
            set -- $line
            ip="${7}"
            time_login="${2}"
            protocol="${3}"
            ip_short=$(echo "$protocol" | sed 's/tcp://g' | cut -d. -f1-3)
            
            now=$(tim2sec "$timenow")
            client_time=$(tim2sec "$time_login")
            (( now - client_time < 40 )) && \
            ! grep -q "$ip $ip_short" /tmp/tr && \
            echo "$user $ip ($(get_country "$ip")) $time_login WIB" >> /tmp/tr
        done
    done

    [[ -s /tmp/tr ]] || return

    for user in "${users[@]}"; do
        local logins=$(grep -w "$user" /tmp/tr | wc -l)
        local details=$(grep -w "$user" /tmp/tr | cut -d' ' -f2- | nl -s'. ' | while read line; do printf "├ %-20s\n" "$line"; done)
        
        # Manejo de tráfico
        local downlink=$(xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2 || echo "0")
        local total_usage=$(( $(cat /etc/limit/trojan/$user 2>/dev/null || echo "0") + downlink ))
        echo "$total_usage" > /etc/limit/trojan/$user
        xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1

        # Verificar límites
        local max_logins=$(cat /etc/trojan/notif 2>/dev/null || echo "3")
        local user_limit=$(cat /etc/trojan/$user 2>/dev/null || echo "999999999999")

        if (( total_usage > user_limit )); then
            send_notification "TROJAN" "$user" "$logins" "$(convert $total_usage)" "$details" "DELETE (Límite de datos)"
            # Lógica de eliminación...
        elif (( logins >= max_logins )); then
            if [[ "$type" = "lock" ]]; then
                send_notification "TROJAN" "$user" "$logins" "$(convert $total_usage)" "$details" "LOCK ($waktulock mins)"
                # Lógica de bloqueo...
            else
                send_notification "TROJAN" "$user" "$logins" "$(convert $total_usage)" "$details" "DELETE (Multi-Login)"
                # Lógica de eliminación...
            fi
        elif (( logins > 1 )); then
            send_notification "TROJAN" "$user" "$logins" "$(convert $total_usage)" "$details" "WARNING"
        fi
    done
}

# =============================================
# EJECUCIÓN PRINCIPAL
# =============================================

# Limpiar procesos bash excedentes
(( $(pgrep bash | wc -l) > 20 )) && killall bash

# Ejecutar monitoreo en paralelo
vmess &
vless &
trojan &
wait

# Limpieza final
rm -f /tmp/{vm,vl,tr}
