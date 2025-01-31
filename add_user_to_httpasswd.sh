#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 USER"
    exit 1
fi

USER=$1
BACKUPS_DIR="/data/registry/auth"
HTPASSWD_FILE="$BACKUPS_DIR/htpasswd"
BACKUP_PREFIX="httpasswd-pre-"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="$BACKUP_PREFIX$TIMESTAMP"

# Create the backups directory if it doesn't exist
mkdir -p $BACKUPS_DIR

# Create a backup of the current htpasswd file
cp "$HTPASSWD_FILE" "$BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"

# Prompt the user for the password in a more interactive way
echo -n "What is the password for $USER: "  # Prompt without newline
# Read the password silently
read -s PASSWORD
echo  # Newline after input

# Add the new user and password to the htpasswd file using Docker
docker run --rm -v "$BACKUPS_DIR:/auth" httpd:2.4 htpasswd -B -b /auth/htpasswd "$USER" "$PASSWORD"
echo "User '$USER' with password '********' added to the htpasswd file."

