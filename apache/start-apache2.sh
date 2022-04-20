#!/bin/bash
source /etc/apache2/envvars
[ -f /etc/ssl/le/fullchain.pem ] && a2ensite default-ssl
exec apache2 -D FOREGROUND
