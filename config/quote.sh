#!/bin/bash
REPO="https://raw.githubusercontent.com/MuhammadIdsal/BangJali-Modder/main/"
SERVICES=("limitvmess" "limitvless" "limittrojan" "limitshadowsocks")
BINARIES=("vmess" "vless" "trojan" "shadowsocks")
remove_existing() {
    local service_name="$1"
    local bin_file="$2"

    if systemctl list-units --full --all | grep -q "$service_name"; then
        systemctl stop "$service_name"
        systemctl disable "$service_name"
    fi

    if [[ -f "/etc/systemd/system/$service_name.service" ]]; then
        rm -f "/etc/systemd/system/$service_name.service"
    fi

    if [[ -f "$bin_file" ]]; then
        rm -f "$bin_file"
    fi
}

for i in "${!SERVICES[@]}"; do
    service="/etc/systemd/system/${SERVICES[$i]}.service"
    binary="/etc/xray/limit.${BINARIES[$i]}"
    remove_existing "${SERVICES[$i]}" "$binary"
done

for i in "${!SERVICES[@]}"; do
    wget -q -O "/etc/systemd/system/${SERVICES[$i]}.service" "${REPO}files/${SERVICES[$i]}.service" && chmod 644 "/etc/systemd/system/${SERVICES[$i]}.service"
    wget -q -O "/etc/xray/limit.${BINARIES[$i]}" "${REPO}files/${BINARIES[$i]}" && chmod +x "/etc/xray/limit.${BINARIES[$i]}"
done

systemctl daemon-reload
for service in "${SERVICES[@]}"; do
    systemctl enable --now "$service"
done

rm -f "$0"
