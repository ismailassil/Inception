#!/bin/bash

# Install the WordPressCLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

## Change the permissions of wp-cli.phar and move it the bin/wp
## so that we use `wp` instead of `wp-cli.phar`
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

alias wp='wp --allow-root'
alias wpcs='wp config set'
## WP_PATH is where WordPress files are located
alias WP_PATH='/var/www/html/'

# Download WordPress
cd $WP_PATH
wp core download
chown -R www-data:www-data /var/www/html/

## Read the Configuration file of php `wp-config-sample.conf` to learn more
## -> Without the `wp-config.php` file their will be no configure
mv wp-config-sample.php wp-config.php

# Configure the WordPress before Installing it
wpcs SERVER_PORT 3306 --path=$WP_PATH
wpcs DB_NAME $MYSQL_DB --path=$WP_PATH
wpcs DB_USER $MYSQL_USER --path=$WP_PATH
wpcs DB_PASSWORD $MYSQL_PASSWORD --path=$WP_PATH
wpcs DB_HOST 'mariadb:3306' --path=$WP_PATH

## Installing WordPress
wpcs core install	--url=$DOMAINE_NAME --title=$TITLE	\
					--admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD	\
					--admin_email=$WP_ADMIN_EMAIL --path=$WP_PATH

### Adding a new user to WordPress
wpcs user create	$WP_USER $WP_USER_EMAIL --role=$WP_USER_ROLE	\
					--user_pass=$USER_PASSWORD --path=$WP_PATH

#############