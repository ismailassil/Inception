#!/bin/bash

echo "Starting Mariadb..."

service mariadb status
service mariadb start

# wait for the service to start
sleep 2

echo "Configuring Mariadb..."

database_name="wordpress_db"
echo "- Creating {$database_name} database"
mariadb -e "create database if not exists $database_name"

new_user="wordpress_user"
password='pass@123'
echo "- Creating a new user {$new_user} with privileges to {$database_name} database"
mariadb -e "create user if not exists '$new_user'@'localhost' identified by '$password'"
## Permissions
mariadb -e "grant all privileges on $database_name.* to '$new_user'@'localhost'"

sleep 1

mariadb -e "flush privileges"

echo "Mariadb has been step up successfully"
