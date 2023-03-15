#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
#  *                              AddGnsUser
#    
#    Author: Bill Fritz
#    Description: Add user to the server, and add the user to the gns3 groups, set xrdp
#    Last Modified: 2023-03-15
#    
#---------------------------------------------------------------------------------------------------

NUSER=$1
NGRP="docker kvm libvirt qemu"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

add_user() {
    useradd -m -s /bin/bash "$NUSER"
    PASSWORD=$(openssl rand -base64 12)
    echo "$NUSER:$PASSWORD" | chpasswd
    echo "User $NUSER created with password $PASSWORD"
}

assign_groups() {
    for i in $NGRP; do
        usermod -aG "$i" "$NUSER"
    done
    echo "User $NUSER added to groups $NGRP"
}

configure_xrdp() {
    echo gnome-session >~/.xsession
}

main() {
    add_user
    assign_groups
    configure_xrdp
}

main