#!/bin/bash

if [[ -f /var/www/app/init.sql ]]; then
	echo "=> Running MySQL to init app database"
    
    /usr/bin/mysqld_safe > /dev/null 2>&1 &
    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MySQL service startup"
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    echo "=> Initializing Database"
    mysql < /var/www/app/init.sql
    if [[ $? -eq 0 ]]; then
    	echo "Database initialized, removing sql"
    	rm /var/www/app/init.sql
    fi
    
    mysqladmin -uroot shutdown
else
	echo "Init script is now missing"
fi
