FROM ubuntu:latest
MAINTAINER Lucas Vidaguren <lucas.vidaguren@asivas.com.ar>

RUN apt-get update

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y install tzdata
RUN ln -s -f /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
RUN dpkg-reconfigure tzdata
# Install packages
RUN apt-get -y install supervisor lamp-server^ php-gd php-curl php-xdebug git vim
RUN apt install -y phpmyadmin php-mbstring php-gettext

# Add image configuration and scripts
ADD apache/start-apache2.sh /start-apache2.sh
ADD apache/configure-php.sh /configure-php.sh
ADD mysql/start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD mysql/my.cnf /etc/mysql/conf.d/my.cnf
ADD apache/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD mysql/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Add MySQL utils
ADD mysql/create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD mysql/init-db.sh /init-db.sh

# Add Pasquino Install utils
ADD pasquino/get-pasquino.sh /init-pasquino.sh

RUN chmod 755 /*.sh

# config to enable .htaccess
ADD apache/default.conf /etc/apache2/sites-available/000-default.conf
ADD apache/ports.conf /etc/apache2/ports.conf
RUN a2enmod rewrite

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 20M
ENV PHP_POST_MAX_SIZE 20M

# Add volumes for MySQL
VOLUME ["/etc/mysql", "/var/lib/mysql" ]

# Configure locales
#RUN locale-gen en_US en_US.UTF-8
#RUN locale-gen es_AR es_AR.UTF-8
#RUN dpkg-reconfigure locales

#Configure PHP.ini
RUN /configure-php.sh

EXPOSE 80 3306
CMD ["/run.sh"]
