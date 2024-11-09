#!/bin/bash

###### STARTING mariaDB
service mariadb start

# WAIT FOR THE SERVICE TO START
sleep 3

###### CONFIGURING mariaDB
## CREATE A NEW DATABASE
mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB"
## CREATE A NEW USER
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'"
## GRANTING PERMISSIONS TO THE USER
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'localhost'"

sleep 1

## APPLYING THE PERMISSIONS - Forces the server to reload the grant tables
mariadb -e "FLUSH PRIVILEGES"

## SET A NEW PASSWORD FOR 'root'
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'"

sleep 3

###### SHUTDOWN THE mariaDB TO APPLY THE CONFIGURATION
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

###### STARTING THE mariaDB WITH SOME SAFETY FEATURES SUCH AS
####### RESTARTING THE SERVER WHEN AN ERROR OCCURS...
####### IT WILL START THE SERVER IN FOREGROUND MODE
####### SO THAT THE CONTAINER WILL NOT EXIT
exec mysqld_safe --bind_address=0.0.0.0
