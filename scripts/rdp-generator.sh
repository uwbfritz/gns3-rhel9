#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if a username was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Read the username from command line arguments
USERNAME=$1

# Generate the RDP file contents in a variable
RDP_FILE=$(cat <<EOF
screen mode id:i:2
desktopwidth:i:1024
desktopheight:i:768
session bpp:i:32
winposstr:s:0,1,1136,450,1614,980
full address:s:$USERNAME.$HOSTNAME
username:s:$USERNAME
EOF
)

if [ ! -d "/home/$USERNAME" ]; then
    echo "User $USERNAME does not exist, cannot generate RDP file"
    exit 1
fi

# Save the RDP file to disk
echo "$RDP_FILE" >/home/"$USERNAME"/"$USERNAME.rdp"
# Change the permissions on the RDP file
chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/"$USERNAME.rdp"

echo "RDP file generated for $USERNAME"