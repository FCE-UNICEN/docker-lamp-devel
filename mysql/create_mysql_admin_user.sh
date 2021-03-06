#!/bin/bash

# Remove pre-installed database
rm -rf /var/lib/mysql/*

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

echo "MySQL user 'root' has no password but only allows local connections"
echo "MySQL user: moodleuser pass: moodle host: localhost port: 3306"

mysqladmin -uroot shutdown
