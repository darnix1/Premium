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
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
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
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
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
