#!/bin/bash
echo "    => Adding xdebug config"
sed s/\;\ Local/"[xdebug]\nxdebug.remote_enable = 1\nxdebug.remote_port = 9000\nxdebug.remote_connect_back =1\n \n; Local"/ /etc/php/7.2/apache2/php.ini > /etc/php/7.2/apache2/php.ini.xdebug

mv -f /etc/php/7.2/apache2/php.ini.xdebug  /etc/php/7.2/apache2/php.ini
