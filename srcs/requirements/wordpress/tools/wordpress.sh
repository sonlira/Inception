#!/bin/bash
set -e

MAX_RETRIES=30
ITER=0

echo "Checking MariaDB connection..."

while ! mariadb -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1; do
	ITER=$((ITER + 1))
	if [ $ITER -eq $MAX_RETRIES ]; then
		echo "Error: MariaDB did not respond after $MAX_RETRIES attempts. Aborting."
		exit 1
	fi
	echo "Attempt $ITER/$MAX_RETRIES: MariaDB is not ready yet..."
	sleep 2

done
echo "Connection established successfully."

cd /var/www/html

wget https://raw.githubusercontent.com/wp-cli/builds/med/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

if [ ! -f "wp-config.php" ]; then

	wp core download --allow-root

	wp config create \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=mariadb:3306 --allow-root
	
	wp core install \
		--url=$DOMAIN_NAME \
		--title=$SITE_TITLE \
		--admin_user=$ADMIN_USER \
		--admin_password=$ADMIN_PASSWORD \
		--admin_email=$ADMIN_EMAIL --allow-root
	
	wp user create $USER_LOGIN $USER_EMAIL --role=author --user_pass=$USER_PASSWORD --allow-root
	
fi

sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

mkdir -p /run/php

exec php-fpm8.2 -F