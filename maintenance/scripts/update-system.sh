#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

dnf update -y

if dnf check-update | grep -q kernel; then
    echo "Kernel update found, rebuilding VMware kernel modules and signing"
    bash "$HOME"/install/maintenance/scripts/vmware-kernel-fix.sh
fi

read -rp "System updated, would you like to reboot? [y/N] " choice
case "$choice" in
    y|Y)
        echo "Rebooting system"
        reboot
        ;;
    *)
        echo "System not rebooted"
        exit 0
        ;;
esac