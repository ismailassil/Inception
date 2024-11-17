#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

# Install the WordPressCLI
curl -O -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wordpressCli \
	&& echo -e "${GREEN}[✓] WordPress CLI downloaded successfully!${RESET}"

## Change the permissions of wp-cli.phar and move it to /usr/local/bin/wp
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp \
	&& echo -e "${GREEN}[✓] WordPress CLI installed successfully!${RESET}"

## Changing the listening port of php-fpm from unix sockets to 9000 port
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf \
	&& echo -e "${GREEN}[✓] PHP-FPM listening port changed to 9000.${RESET}"

## WP_PATH is where WordPress files are located
WP_PATH='/var/www/wordpress'

if [[ -z "$WP_PATH" ]]; then
	echo "Error: Required environment variables are not set!"
	exit 1
fi

# Download WordPress
mkdir -p "$WP_PATH"
cd "$WP_PATH" || exit
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "Downloading WordPress..."
	wp core download --path="$WP_PATH" --allow-root \
		&& echo -e "${GREEN}[✓] WordPress downloaded successfully!${RESET}"

	## Read the Configuration file of php `wp-config-sample.conf` to learn more
	mv "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php" \
		&& echo -e "${GREEN}[✓] wp-config.php file created successfully!${RESET}"
else
	echo "WordPress is already downloaded."
fi

# Set up WordPress database credentials and connection
wp config set SERVER_PORT 3306 --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] Set SERVER_PORT in wp-config.php.${RESET}"
wp config set DB_NAME $MYSQL_DB --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] Set DB_NAME in wp-config.php.${RESET}"
wp config set DB_USER $MYSQL_USER --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] Set DB_USER in wp-config.php.${RESET}"
wp config set DB_PASSWORD $MYSQL_PASSWORD --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] Set DB_PASSWORD in wp-config.php.${RESET}"
wp config set DB_HOST "$__MYSQL_HOST__" --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] Set DB_HOST in wp-config.php.${RESET}"

## Installing WordPress
## TO BE CHECKED !!!!
# if ! wp core is-installed --path="$WP_PATH" --allow-root; then
wp core install	--url=$DOMAINE_NAME --title=$TITLE \
				--admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD \
				--admin_email=$WP_ADMIN_EMAIL --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] WordPress installed successfully!${RESET}" \
	|| echo -e "${RED}[X] Failed to create new WordPress user '$WP_USER'.${RESET}"
# else
# 	echo -e "${GREEN}[✓] WordPress is already installed.${RESET}"
# fi

### Adding a new user to WordPress
wp user create	$WP_USER $WP_USER_EMAIL --role=$WP_USER_ROLE \
				--user_pass=$WP_USER_PASSWORD --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] New WordPress user '$WP_USER' created successfully!${RESET}" \
	|| echo -e "${RED}[X] Failed to create new WordPress user '$WP_USER'.${RESET}"

# Correct ownership of the WordPress directory for web server access
chown -R www-data:www-data "$WP_PATH" \
	&& echo -e "${GREEN}[✓] Corrected ownership of WordPress files.${RESET}"

# Installing new theme and activating it
wp theme install twentytwentytwo --activate --path="$WP_PATH" --allow-root \
	&& echo -e "${GREEN}[✓] 'twentytwentytwo' theme installed and activated successfully!${RESET}"

#############
## Start the PHP FastCGI Process Manager in the foreground (-F)
echo -e "${GREEN}[✓] Starting PHP-FPM.${RESET}"
/usr/sbin/php-fpm7.4 -F
