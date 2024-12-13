#!/bin/bash

GREEN='\033[1;32m'
RESET='\033[0m'
MYSQL_PASSWORD=`cat /run/secrets/db_password`
MYSQL_ROOT_PASSWORD=`cat /run/secrets/db_root_password`

service mariadb start

sleep 5

mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB"
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'"
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'%'"
mariadb -e "FLUSH PRIVILEGES"

mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

##############################################################################
echo -e "${GREEN}[✓] MySQL started in safe mode, bound to 0.0.0.0.${RESET}"
exec mysqld_safe --bind_address=0.0.0.0
