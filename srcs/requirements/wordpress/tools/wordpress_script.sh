#!/bin/bash

GREEN='\033[1;32m'
RESET='\033[0m'
MYSQL_PASSWORD=`cat /run/secrets/db_password`
WP_USER_PASSWORD=`cat /run/secrets/wp_password`
WP_ADMIN_PASSWORD=`cat /run/secrets/wp_admin_password`

curl -O -s https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar >/dev/null 2>&1

chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

sed --in-place '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf

WP_PATH='/var/www/wordpress'
mkdir -p "$WP_PATH"

wp core download --path="$WP_PATH" --allow-root

mv "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"

wp config set DB_NAME $MYSQL_DB --path="$WP_PATH" --allow-root
wp config set DB_USER $MYSQL_USER --path="$WP_PATH" --allow-root
wp config set DB_PASSWORD $MYSQL_PASSWORD --path="$WP_PATH" --allow-root
wp config set DB_HOST "$__MYSQL_HOST__" --path="$WP_PATH" --allow-root

wp config set WP_REDIS_HOST $REDIS_CT_NAME --path="$WP_PATH" --allow-root
wp config set WP_REDIS_PORT $REDIS_CT_PORT --path="$WP_PATH" --allow-root

wp core install	--url=$DOMAINE_NAME --title=$TITLE \
				--admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD \
				--admin_email=$WP_ADMIN_EMAIL --path="$WP_PATH" --allow-root

wp user create	$WP_USER $WP_USER_EMAIL --role=$WP_USER_ROLE \
				--user_pass=$WP_USER_PASSWORD --path="$WP_PATH" --allow-root

chown -R www-data:www-data "$WP_PATH"

wp theme install twentytwentytwo --activate --path="$WP_PATH" --allow-root

wp plugin install redis-cache --activate --path="$WP_PATH" --allow-root
wp redis enable redis-cache --path="$WP_PATH" --allow-root

####################################################
echo -e "${GREEN}[✓] Starting PHP-FPM.${RESET}"
exec /usr/sbin/php-fpm7.4 -F
