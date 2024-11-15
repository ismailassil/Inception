#!/bin/bash

# Install the WordPressCLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

## Change the permissions of wp-cli.phar and move it the bin/wp
## so that we use `wp` instead of `wp-cli.phar`
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

## Changing the listening port of php-fpm from unix sockets to 9000 port
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf

## WP_PATH is where WordPress files are located
WP_PATH='/var/www/wordpress'

if [[ -z "$WP_PATH" ]]; then
    echo "Error: Required environment variables are not set!"
    exit 1
fi

# Wait until MariaDB is available
until mysqladmin ping -h mariadb -P 3306 --silent; do
	echo "Waiting for mariaDB to be available..."
	sleep 5
done

# Download WordPress
mkdir -p "$WP_PATH"
cd "$WP_PATH" || exit
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "Downloading WordPress..."
	while ! wp core download --path="$WP_PATH" --allow-root; do
		echo "Waiting for WordPress download to succeed..."
		sleep 2
	done
else
	echo "WordPress is already downloaded."
fi

## Read the Configuration file of php `wp-config-sample.conf` to learn more
## -> Without the `wp-config.php` file their will be no configuration
mv "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"

# Set up WordPress database credentials and connection
# Configure the WordPress with mariaDB
wp config set SERVER_PORT 3306 --path="$WP_PATH" --allow-root
wp config set DB_NAME $MYSQL_DB --path="$WP_PATH" --allow-root
wp config set DB_USER $MYSQL_USER --path="$WP_PATH" --allow-root
wp config set DB_PASSWORD $MYSQL_PASSWORD --path="$WP_PATH" --allow-root
## Set the mariaDB Container exposed port with WordPress Database
wp config set DB_HOST 'mariadb:3306' --path="$WP_PATH" --allow-root

## Installing WordPress
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
	wp core install	--url=$DOMAINE_NAME --title=$TITLE	\
					--admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD	\
					--admin_email=$WP_ADMIN_EMAIL --path="$WP_PATH" --allow-root
fi

### Adding a new user to WordPress
wp user create	$WP_USER $WP_USER_EMAIL --role=$WP_USER_ROLE	\
				--user_pass=$f --path="$WP_PATH" --allow-root

# Correct ownership of the WordPress directory for web server access
chown -R www-data:www-data "$WP_PATH"

#############
## Start the PHP FastCGI Process Manager in the foreground (-F)
/usr/sbin/php-fpm7.4 -F
