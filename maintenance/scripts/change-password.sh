#!/usr/bin/env bash


# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if the user provided a username
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Set the username
NUSER=$1

# Change the user's password to a random string
PASSWORD=$(openssl rand -base64 12)
echo "$NUSER:$PASSWORD" | chpasswd

# Display the new password
echo "User $NUSER new password is $PASSWORD"