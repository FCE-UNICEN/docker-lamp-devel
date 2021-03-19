#!/bin/bash
echo "    => Adding xdebug config"

PHP_MODS_DIR=/etc/php5/mods-available

echo "[xdebug]" >> xdebug.ini
echo "xdebug.remote_enable = 1" >> ${PHP_MODS_DIR}/xdebug.ini
echo "xdebug.remote_port = 9000" >> ${PHP_MODS_DIR}/xdebug.ini
echo "xdebug.remote_connect_back =1" >> ${PHP_MODS_DIR}/xdebug.ini

#otra opción sería ir a php.ini
#sed s/\;\ Local/"[xdebug]\nxdebug.remote_enable = 1\nxdebug.remote_port = 9000\nxdebug.remote_connect_back =1\n \n; Local"/ /etc/php5/apache2/php.ini > /etc/php5/apache2/php.ini.xdebug
#mv -f /etc/php5/apache2/php.ini.xdebug  /etc/php5/apache2/php.ini

php5enmod xdebug

# Default charset de apache
sed -i '/^#AddDefaultCharset UTF-8/s/^#//' /etc/apache2/conf-enabled/charset.conf