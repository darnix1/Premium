#!/bin/bash

## Configuración centralizada
CONFIG_DIR="/etc/xraylimit"
LOG_FILE="/var/log/xraylimit.log"
LOCK_DIR="/tmp/xraylimit.lock"
TEMP_DIR="/tmp/xraylimit.tmp"
mkdir -p "$CONFIG_DIR" "$TEMP_DIR"
chmod 750 "$CONFIG_DIR"
touch "$LOG_FILE"
chmod 640 "$LOG_FILE"

## Funciones básicas mejoradas
log() {
    echo "$(date '+%Y-%m-%d %T') - $1" >> "$LOG_FILE"
    logger -t xraylimit "$1"
}

cleanup() {
    rm -rf "$TEMP_DIR"/*
    find "$LOCK_DIR" -type f -mmin +60 -delete 2>/dev/null
}

sanitize_input() {
    echo "$1" | sed 's/[^a-zA-Z0-9_-]//g'
}

acquire_lock() {
    local lock_name="$1"
    local lock_file="$LOCK_DIR/${lock_name}.lock"
    local timeout=10
    local attempts=0
    
    while [[ $attempts -lt $timeout ]]; do
        if ( set -o noclobber; echo "$$" > "$lock_file" ) 2>/dev/null; then
            trap "release_lock '$lock_name'" EXIT
            return 0
        fi
        sleep 1
        ((attempts++))
    done
    log "Error: No se pudo adquirir el lock para $lock_name"
    return 1
}

release_lock() {
    local lock_name="$1"
    local lock_file="$LOCK_DIR/${lock_name}.lock"
    rm -f "$lock_file"
}

## Configuración de notificaciones
load_notification_config() {
    if [[ -f "$CONFIG_DIR/notify.conf" ]]; then
        source "$CONFIG_DIR/notify.conf"
    else
        CHATID=$(cat /etc/perlogin/id 2>/dev/null)
        KEY=$(cat /etc/perlogin/token 2>/dev/null)
        TIMES="10"
        URL="https://api.telegram.org/bot$KEY/sendMessage"
    fi
}

send_notification() {
    local service="$1"
    local user="$2"
    local ip_count="$3"
    local usage="$4"
    local ip_list="$5"
    local action="$6"
    
    load_notification_config
    
    if [[ -z "$CHATID" || -z "$KEY" ]]; then
        log "Notificación no enviada: Configuración de Telegram incompleta"
        return
    fi

    local message="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ ${service^^} ALERTA</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMINIO:</b> $(cat /etc/xray/domain 2>/dev/null)
<b>USUARIO:</b> ${user}
<b>CONEXIONES:</b> ${ip_count}
<b>USO:</b> ${usage}
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DETALLES:</b>
${ip_list}
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Acción: ${action}</i>
"

    curl -s --max-time "$TIMES" \
        -d "chat_id=$CHATID&disable_web_page_preview=1&text=$message&parse_mode=html" \
        "$URL" >/dev/null 2>&1 || log "Error al enviar notificación para $user"
}

## Funciones de conversión y cálculo
tim2sec() {
    local arg="$1" mult=1 inu=0 prev curr
    
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

convert() {
    local -i bytes="$1"
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

## Funciones de monitoreo mejoradas
get_user_stats() {
    local user="$1"
    local service="$2"
    local stats_file="$TEMP_DIR/${service}_stats.json"
    
    if ! acquire_lock "xray_api"; then
        return 1
    fi
    
    xray api stats --server=127.0.0.1:10085 > "$stats_file"
    release_lock "xray_api"
    
    local downlink=$(jq -r ".stat[] | select(.name == \"user>>>${user}>>>traffic>>>downlink\") | .value" "$stats_file")
    local uplink=$(jq -r ".stat[] | select(.name == \"user>>>${user}>>>traffic>>>uplink\") | .value" "$stats_file")
    
    echo "$downlink $uplink"
}

process_service() {
    local service="$1"
    local tag="$2"
    local log_path="/var/log/xray/access.log"
    local config_file="/etc/xray/config.json"
    local limit_dir="/etc/limit/$service"
    local user_dir="/etc/$service"
    local temp_file="$TEMP_DIR/${service}_users.tmp"
    
    mkdir -p "$limit_dir" "$user_dir"
    chmod 750 "$limit_dir"
    
    # Obtener usuarios válidos
    local users=($(grep "^#${tag} " "$config_file" | awk '{print $2}' | sort -u | xargs -I {} sh -c 'echo "{}" | grep -q "^[a-zA-Z0-9_-]\+$" && echo "{}"'))
    
    if [[ ${#users[@]} -eq 0 ]]; then
        log "No se encontraron usuarios para $service"
        return
    fi
    
    # Procesar logs de forma eficiente
    local now=$(tim2sec $(date +%T))
    
    for user in "${users[@]}"; do
        local safe_user=$(sanitize_input "$user")
        local user_ips_file="$TEMP_DIR/${service}_${safe_user}_ips.tmp"
        
        # Extraer IPs activas
        awk -v user="$user" -v now="$now" '
            $0 ~ "email: " user {
                split($2, time, ":");
                client = (time[1]*3600 + time[2]*60 + time[3]);
                if (now - client < 40) {
                    split($3, proto, ":");
                    ip = $7;
                    print ip " " $2 " WIB : " proto[1];
                }
            }
        ' "$log_path" | sort -u > "$user_ips_file"
        
        local ip_count=$(wc -l < "$user_ips_file")
        local ip_list=$(cat "$user_ips_file" | nl -s '. ' | while read line; do printf "%-20s\n" "$line"; done)
        
        # Obtener estadísticas de uso
        local stats=($(get_user_stats "$user" "$service"))
        local downlink="${stats[0]}"
        local uplink="${stats[1]}"
        local total_usage=$((downlink + uplink))
        
        # Manejo de límites
        local limit_file="$user_dir/$safe_user"
        local usage_file="$limit_dir/$safe_user"
        
        if [[ ! -f "$limit_file" ]]; then
            echo "999999999999" > "$limit_file"
        fi
        
        local limit=$(cat "$limit_file")
        
        if [[ ! -f "$usage_file" ]]; then
            echo "$total_usage" > "$usage_file"
        else
            local previous_usage=$(cat "$usage_file")
            echo "$((previous_usage + total_usage))" > "$usage_file"
        fi
        
        local current_usage=$(cat "$usage_file")
        local usage_display=$(convert "$current_usage")
        local limit_display=$(convert "$limit")
        
        # Verificar límites
        if [[ "$current_usage" -gt "$limit" ]]; then
            handle_limit_exceeded "$service" "$user" "$ip_count" "$usage_display" "$ip_list"
        elif [[ "$ip_count" -gt $(get_notification_threshold "$service") ]]; then
            handle_multi_login "$service" "$user" "$ip_count" "$usage_display" "$ip_list"
        fi
        
        # Resetear estadísticas
        xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>downlink" -reset >/dev/null 2>&1
        xray api stats --server=127.0.0.1:10085 -name "user>>>${user}>>>traffic>>>uplink" -reset >/dev/null 2>&1
    done
}

get_notification_threshold() {
    local service="$1"
    local threshold_file="/etc/${service}/notif"
    
    if [[ -f "$threshold_file" ]]; then
        cat "$threshold_file"
    else
        echo "3"  # Valor por defecto
    fi
}

handle_limit_exceeded() {
    local service="$1"
    local user="$2"
    local ip_count="$3"
    local usage="$4"
    local ip_list="$5"
    
    local safe_user=$(sanitize_input "$user")
    local config_file="/etc/xray/config.json"
    local quota_file="/etc/${service}/userQuota"
    
    # Obtener información del usuario
    local user_info=$(grep -wE "^#${service:0:2}g? $user" "$config_file")
    local exp=$(echo "$user_info" | awk '{print $3}')
    local uuid=$(echo "$user_info" | awk '{print $4}')
    
    # Registrar y notificar
    log "Usuario $user ($service) excedió límite de uso ($usage)"
    send_notification "$service" "$user" "$ip_count" "$usage" "$ip_list" "Límite de datos excedido"
    
    # Eliminar usuario
    sed -i "/^#${service:0:2}g\? $user $exp/,/^},{/d" "$config_file"
    echo "### $user $exp $uuid" >> "$quota_file"
    rm -f "/etc/limit/${service}/${safe_user}"
    
    # Reiniciar servicio
    systemctl restart xray >/dev/null 2>&1
}

handle_multi_login() {
    local service="$1"
    local user="$2"
    local ip_count="$3"
    local usage="$4"
    local ip_list="$5"
    
    local safe_user=$(sanitize_input "$user")
    local config_file="/etc/xray/config.json"
    local lock_file="/etc/${service}/listlock"
    local login_file="/etc/${service}/${safe_user}login"
    local threshold=$(get_notification_threshold "$service")
    local type=$(cat /etc/typexray 2>/dev/null || echo "delete")
    local waktulock=$(cat /etc/waktulock 2>/dev/null || echo "15")
    
    # Registrar intentos de login
    echo "$user $ip_count" >> "$login_file"
    local total_logins=$(wc -l < "$login_file")
    
    # Obtener información del usuario
    local user_info=$(grep -wE "^#${service:0:2}g? $user" "$config_file")
    local exp=$(echo "$user_info" | awk '{print $3}')
    local uuid=$(echo "$user_info" | awk '{print $4}')
    
    if [[ "$total_logins" -ge "$threshold" ]]; then
        log "Usuario $user ($service) con múltiples logins ($ip_count)"
        
        if [[ "$type" == "lock" ]]; then
            # Bloqueo temporal
            send_notification "$service" "$user" "$ip_count" "$usage" "$ip_list" "Bloqueo temporal ($waktulock minutos)"
            
            cat > "/etc/cron.d/xray_${service}_${safe_user}" <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/$waktulock * * * * root /usr/bin/xray $service $user $uuid $exp && rm -f "/etc/cron.d/xray_${service}_${safe_user}"
EOF
            
            echo "### $user $exp $uuid" >> "$lock_file"
            sed -i "/^#${service:0:2}g\? $user $exp/,/^},{/d" "$config_file"
            systemctl restart xray >/dev/null 2>&1
            service cron restart >/dev/null 2>&1
        else
            # Eliminación permanente
            send_notification "$service" "$user" "$ip_count" "$usage" "$ip_list" "Eliminación por múltiples logins"
            
            echo "### $user $exp $uuid" >> "$lock_file"
            sed -i "/^#${service:0:2}g\? $user $exp/,/^},{/d" "$config_file"
            rm -f "$login_file"
            systemctl restart xray >/dev/null 2>&1
        fi
    else
        # Solo notificación
        send_notification "$service" "$user" "$ip_count" "$usage" "$ip_list" "Advertencia de múltiples logins"
    fi
}

## Función principal
main() {
    log "Iniciando monitoreo Xray"
    
    # Limpieza inicial
    cleanup
    
    # Procesar cada servicio
    process_service "vmess" "vmg"
    process_service "vless" "vlg"
    process_service "trojan" "trg"
    
    log "Monitoreo Xray completado"
}

## Ejecución
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Este script debe ejecutarse como root" >&2
    exit 1
fi

# Crear directorios necesarios
mkdir -p "$LOCK_DIR" "$TEMP_DIR"
chmod 700 "$LOCK_DIR"

main
exit 0
