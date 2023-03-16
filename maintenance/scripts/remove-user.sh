#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Ask the user if they are sure they want to remove the user
read -rp "Are you sure you want to remove $1? [y/N] " choice
case "$choice" in
    y|Y)
        echo "Removing user $1"
        userdel -r "$1"
        ;;
    *)
        echo "User $1 not removed"
        exit 0
        ;;
esac

