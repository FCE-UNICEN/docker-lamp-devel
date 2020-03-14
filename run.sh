#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    chown mysql:mysql /var/lib/mysql
    chmod 750 /var/lib/mysql
    cd /var/lib/mysql
    mysqld --initialize-insecure --user mysql > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

echo "=> Installing or updating pasquino"
/init-pasquino.sh

if [[ -f /var/www/app/init.sql ]]; then
	/init-db.sh
fi


exec supervisord -n
