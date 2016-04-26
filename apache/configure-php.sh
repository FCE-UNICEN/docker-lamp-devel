#!/bin/bash
echo "    => Adding xdebug config"
sed s/\;\ Local/"[xdebug]\nxdebug.remote_enable = 1\nxdebug.remote_port = 9000\nxdebug.remote_connect_back =1\n \n; Local"/ /etc/php5/apache2/php.ini > /etc/php5/apache2/php.ini.xdebug

mv -f /etc/php5/apache2/php.ini.xdebug  /etc/php5/apache2/php.ini
