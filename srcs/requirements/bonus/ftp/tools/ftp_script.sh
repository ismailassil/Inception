#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

# 500 OOPS: vsftpd: not found: directory given in 'secure_chroot_dir':/var/run/vsftpd/empty
mkdir -p /var/run/vsftpd/empty

# Create a user for the ftp_server
# -m = --create-home
useradd --create-home $FTP_USERNAME \
	&& echo -e "${GREEN}[✓] User '$FTP_USERNAME' created successfully!${RESET}"

# Create a password for the user
echo "$FTP_USERNAME:$FTP_PASSWORD" | chpasswd \
	&& echo -e "${GREEN}[✓] User Password '$FTP_USERNAME' created successfully!${RESET}"

# Adds the FTP_USER to sudo group
usermod -aG sudo $FTP_USERNAME \
	&& echo -e "${GREEN}[✓] User '$FTP_USERNAME' has been added to 'sudo' group successfully!${RESET}"

FTP_FOLDER=/data/wordpress_files/

# Create Directory for mounting the Wordpress
mkdir -p $FTP_FOLDER \
	&& chown $FTP_USERNAME:$FTP_USERNAME $FTP_FOLDER \
	&& echo -e "${GREEN}[✓] Folder '$FTP_FOLDER' created successfully!${RESET}"

exec vsftpd /etc/vsftpd.conf
