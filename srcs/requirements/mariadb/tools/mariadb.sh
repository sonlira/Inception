#!/bin/bash

mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Instalando base de datos inicial..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

service mariadb start
sleep 2

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Configurando credenciales..."
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
fi

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

exec mysqld --user=mysql