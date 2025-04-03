#!/bin/bash

# Hapus menu yang lama
declare -a files=(
    "backup" "bckpbot" "bottelegram" "install-up" "m-allxray" "m-backup" "m-bot"
    "m-sshovpn" "m-ssws" "m-system" "m-tcp" "m-theme" "m-trojan" "m-update"
    "m-vless" "m-vmess" "menu" "restore" "running" "tendang" "trial" "trialssh"
    "trialtrojan" "trialvless" "trialvmess" "update" "xraylimit"
)

for file in "${files[@]}"; do
    rm -rf "/usr/bin/$file"
done

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
    echo -ne "  \033[0;33mProcesando \033[1;37m- \033[0;33m["
    
    # Longitud de la barra de progreso
    BAR_LENGTH=18
    POSITION=0
    DIRECTION=1  # 1 para derecha, -1 para izquierda
    
    # Colores dinámicos para la barra de progreso
    COLORS=("\033[0;31m" "\033[0;32m" "\033[0;33m" "\033[0;34m" "\033[0;35m" "\033[0;36m")
    COLOR_INDEX=0

    while true; do
        # Mover el cursor al inicio de la barra (evita corchetes duplicados)
        echo -ne "\r"
        echo -ne "  \033[0;33mProcesando \033[1;37m- \033[0;33m["
        
        # Dibujar espacios y el punto animado
        for ((i = 0; i < BAR_LENGTH; i++)); do
            if [ $i -eq $POSITION ]; then
                echo -ne "${COLORS[$((COLOR_INDEX % ${#COLORS[@]}))]}."
            else
                echo -ne " "
            fi
        done
        
        # Cerrar con UN solo corchete
        echo -ne "\033[0;33m]"
        
        # Actualizar posición y dirección
        ((POSITION += DIRECTION))
        if [ $POSITION -eq $((BAR_LENGTH - 1)) ] || [ $POSITION -eq 0 ]; then
            ((DIRECTION *= -1))
            ((COLOR_INDEX++))
        fi
        
        # Comprobar si el proceso terminó
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        
        # Pausa para la animación
        sleep 0.1s
    done
    
    # Mensaje final (OK)
    echo -e "\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

res1() {
    base_url="https://raw.githubusercontent.com/darnix1/mx2/main/menu"
    declare -A downloads=(
        ["backup"]="backup.sh" ["bckpbot"]="bckpbot.sh" ["bottelegram"]="bottelegram.sh"
        ["install-up"]="../install-up.sh" ["m-allxray"]="m-allxray.sh" ["m-backup"]="m-backup.sh"
        ["m-bot"]="m-bot.sh" ["m-sshovpn"]="m-sshovpn.sh" ["m-ssws"]="m-ssws.sh" ["m-system"]="m-system.sh"
        ["m-tcp"]="m-tcp.sh" ["m-theme"]="m-theme.sh" ["m-trojan"]="m-trojan.sh" ["m-update"]="m-update.sh"
        ["m-vless"]="m-vless.sh" ["m-vmess"]="m-vmess.sh" ["menu"]="menu.sh" ["restore"]="restore.sh"
        ["running"]="running.sh" ["tendang"]="tendang.sh" ["trial"]="trial.sh" ["trialssh"]="trialssh.sh"
        ["trialtrojan"]="trialtrojan.sh" ["trialvless"]="trialvless.sh" ["trialvmess"]="trialvmess.sh"
        ["update"]="update.sh" ["xraylimit"]="xraylimit.sh"
    )

    for file in "${!downloads[@]}"; do
        wget -q -O "/usr/bin/$file" "$base_url/${downloads[$file]}" && chmod +x "/usr/bin/$file"
    done
    
    chmod +x /usr/bin/*
    clear
}

echo -e "\n  \033[1;91m Update Script...\033[1;37m"
fun_bar 'res1'

echo -e ""
menu
