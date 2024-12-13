#!/bin/bash

GREEN='\033[1;32m'
RESET='\033[0m'
FTP_PASSWORD=`cat /run/secrets/ftp_password`

mkdir -p /var/run/vsftpd/empty

useradd --create-home $FTP_USERNAME

echo "$FTP_USERNAME:$FTP_PASSWORD" | chpasswd

FTP_FOLDER="/data/wordpress_files/"

mkdir -p $FTP_FOLDER \
	&& chown $FTP_USERNAME:$FTP_USERNAME $FTP_FOLDER \
	&& chmod 755 $FTP_FOLDER

####################################################
echo -e "${GREEN}[✓] Starting FTP.${RESET}"
exec vsftpd /etc/vsftpd.conf
