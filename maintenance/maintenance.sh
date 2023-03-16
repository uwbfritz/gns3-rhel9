#!/usr/bin/env bash

# ANSI color codes
red='\033[0;31m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
reset='\033[0m' # Reset color

for file in ./scripts/*.sh; do
    if [ ! -x "$file" ]; then
        echo -e "${yellow}chmod +x ${file}${reset}"
    fi
done

echo -e "${magenta}Choose an option below:${reset}"

# Display menu
while true; do
    echo ""
    echo "Choose an option:"
    echo -e "${blue}1.${reset} Add a new user"
    echo -e "${blue}2.${reset} Generate an RDP file for a user"
    echo -e "${blue}3.${reset} Change a user's password"
    echo -e "${blue}4.${reset} Remove a user"
    echo -e "${blue}5.${reset} Update the system"
    echo -e "${red}q.${reset} Quit"
    read -rp "> " choice

    case "$choice" in
        1)
            read -rp "Enter the username: " username
            ./scripts/add-gns-user.sh "$username"
            ;;
        2)
            read -rp "Enter the username: " username
            ./scripts/rdp-generator.sh "$username"
            ;;
        3)
            read -rp "Enter the username: " username
            ./scripts/change-password.sh "$username"
            ;;
        4)
            read -rp "Enter the username: " username
            ./scripts/remove-user.sh "$username"
            ;;
        5)
            ./scripts/update-system.sh
            ;;
        q|Q)
            echo -e "${cyan}Goodbye${reset}"
            exit 0
            ;;
        *)
            echo -e "${red}Invalid option${reset}"
            ;;
    esac
done
