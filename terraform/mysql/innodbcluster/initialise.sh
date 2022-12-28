#!/bin/sh

# Install MySQL client tools
apk add --no-cache mysql-client

mysql_ready() {
    mysqladmin ping --host="$MYSQL_HOST" --user="$MYSQL_ROOT_USER" --password="$MYSQL_ROOT_PASSWORD" > /dev/null 2>&1
}

while ! ( mysql_ready )
do
    sleep 3
    echo "Waiting for mysql ..."
done

# Throw an error from here if failed
set -e

mysql_execute(){
    SQL=$1
    
    mysql -h"$MYSQL_HOST" -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" -e "$SQL"
}

echo "Creating new user..."
mysql_execute "CREATE USER IF NOT EXISTS '$NEW_MYSQL_USER'@'localhost' IDENTIFIED BY '$NEW_MYSQL_USER_PASSWORD'"

echo "Creating new database..."
mysql_execute "CREATE DATABASE IF NOT EXISTS $NEW_MYSQL_DATABASE"

echo "Granting access to new database..."
mysql_execute "GRANT ALL PRIVILEGES ON $NEW_MYSQL_DATABASE.* TO '$NEW_MYSQL_USER'@'%'"

echo "Done"
