#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

# Ensure necessary environment variables are set
if [[ -z "$MYSQL_ROOT_PASSWORD" || -z "$MYSQL_DB" || -z "$MYSQL_USER" || -z "$MYSQL_PASSWORD" ]]; then
	echo "Error: Required environment variables are not set!"
	exit 1
fi

###### STARTING MARIADB
service mariadb start && echo -e "${GREEN}[✓] mariadb started successfully!${RESET}"

## WAIT FOR THE SERVICE TO START
sleep 5

###### CONFIGURING mariaDB
## CREATE A NEW DATABASE
mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB" \
	&& echo -e "${GREEN}[✓] Database '$MYSQL_DB' created successfully!${RESET}"

## CREATE A NEW USER
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'" \
	&& echo -e "${GREEN}[✓] User '$MYSQL_USER' created successfully!${RESET}"

## GRANTING PERMISSIONS TO THE USER
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'%'" \
	&& echo -e "${GREEN}[✓] All privileges granted to user '$MYSQL_USER' on database '$MYSQL_DB' successfully!${RESET}"

## APPLYING THE PERMISSIONS - Forces the server to reload the grant tables
mariadb -e "FLUSH PRIVILEGES" \
	&& echo -e "${GREEN}[✓] Privileges flushed successfully! ${RESET}"

###### SET A NEW PASSWORD FOR 'root' IF NOT SETTED YET
###### SHUTDOWN THE MARIADB TO APPLY THE CONFIGURATION
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown \
	&& echo -e "${GREEN}[✓] Shutting down MariaDB to apply the configuration${RESET}"

###### STARTING THE mariaDB WITH SOME SAFETY FEATURES SUCH AS
####### RESTARTING THE SERVER WHEN AN ERROR OCCURS...
####### IT WILL START THE SERVER IN FOREGROUND MODE
####### SO THAT THE CONTAINER WILL NOT EXIT
echo -e "${GREEN}[✓] MySQL started in safe mode, bound to 0.0.0.0.${RESET}"
exec mysqld_safe --port=3306 --bind_address=0.0.0.0 --datadir="/var/lib/mysql"
