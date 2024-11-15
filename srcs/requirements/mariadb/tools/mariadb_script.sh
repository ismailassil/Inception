#!/bin/bash
DOMAINE_NAME="iassil.42.fr"

MYSQL_DB="inc_database"
MYSQL_USER="iassil"
MYSQL_PASSWORD="@just_12_a_43_passwd@"
MYSQL_ROOT_PASSWORD="#@the_root_42_passwd@#"

TITLE="Void*"
WP_ADMIN_USER="iassil"
WP_ADMIN_PASSWORD="@passw@00"
WP_ADMIN_EMAIL="iassil@gmail.com"
WP_USER_ROLE="author"

WP_USER="user1"
WP_USER_EMAIL="just_a_user@gmail.com"
USER_PASSWORD="@passw123"

# Ensure necessary environment variables are set
if [[ -z "$MYSQL_ROOT_PASSWORD" || -z "$MYSQL_DB" || -z "$MYSQL_USER" || -z "$MYSQL_PASSWORD" ]]; then
    echo "Error: Required environment variables are not set!"
    exit 1
fi

###### STARTING mariaDB
service mariadb start

# ## WAIT FOR THE SERVICE TO START
until mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" > /dev/null 2>&1; do
	echo "Waiting for mariaDB to start..."
	sleep 2
done

###### CONFIGURING mariaDB
## CREATE A NEW DATABASE
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB"

## CREATE A NEW USER
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'"
## GRANTING PERMISSIONS TO THE USER
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'localhost'"

sleep 1

## APPLYING THE PERMISSIONS - Forces the server to reload the grant tables
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"

## SET A NEW PASSWORD FOR 'root'
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'"

sleep 3

###### SHUTDOWN THE mariaDB TO APPLY THE CONFIGURATION
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

###### STARTING THE mariaDB WITH SOME SAFETY FEATURES SUCH AS
####### RESTARTING THE SERVER WHEN AN ERROR OCCURS...
####### IT WILL START THE SERVER IN FOREGROUND MODE
####### SO THAT THE CONTAINER WILL NOT EXIT
exec mysqld_safe --bind_address=0.0.0.0
