#!/bin/bash

###### STARTING mariaDB
service mariadb start

# WAIT FOR THE SERVICE TO START
sleep 3

###### CONFIGURING mariaDB
database_name="wordpress_db"
new_user="wordpress_user"
password='pass@123'
root_password='pass@123'

## CREATE A NEW DATABASE
mariadb -e "CREATE DATABASE IF NOT EXISTS $database_name"
## CREATE A NEW USER
mariadb -e "CREATE USER IF NOT EXISTS '$new_user'@'localhost' IDENTIFIED BY '$password'"
## GRANTING PERMISSIONS TO THE USER
mariadb -e "GRANT ALL PRIVILEGES ON $database_name.* TO '$new_user'@'localhost'"

sleep 1

## APPLYING THE PERMISSIONS - Forces the server to reload the grant tables
mariadb -e "FLUSH PRIVILEGES"

## SET A NEW PASSWORD FOR 'root'
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_password'"

sleep 3

###### SHUTDOWN THE mariaDB TO APPLY THE CONFIGURATION
mysqladmin -u root -p"$root_password" shutdown

###### STARTING THE mariaDB WITH SOME SAFETY FEATURES SUCH AS
####### RESTARTING THE SERVER WHEN AN ERROR OCCURS...
mysql_safe