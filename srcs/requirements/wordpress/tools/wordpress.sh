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

if [ ! -f ./wp-config.php ]; then

	wp core download --allow-root

	wp config create \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=$MYSQL_HOSTNAME \
		--allow-root
	
	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="$WP_SITE_TITLE" \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email \
		--allow-root
	
	wp user create $WP_USER_LOGIN $WP_USER_EMAIL \
		--role=author \
		--user_pass=$WP_USER_PASSWORD \
		--allow-root
	
	wp theme install twentysixteen --activate --allow-root

fi

exec php-fpm8.2 -F