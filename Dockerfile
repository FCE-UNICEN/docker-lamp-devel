FROM ubuntu:trusty
MAINTAINER Lucas Vidaguren <lucas.vidaguren@asivas.com.ar>

# Install packages
RUN apt-get update
RUN apt-get -y install supervisor apache2 libapache2-mod-php5 php5-mysql pwgen php5-mcrypt php5-gd php5-curl php5-xmlrpc php5-intl curl php5-xdebug git vim

# Add image configuration and scripts
ADD apache/start-apache2.sh /start-apache2.sh
ADD apache/configure-php.sh /configure-php.sh

ADD run.sh /run.sh
RUN chmod 755 /*.sh

ADD apache/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# Add Pasquino Install utils
ADD pasquino/get-pasquino.sh /init-pasquino.sh

# Add Pasquino app getter
ADD pasquino/init-app.sh /init-app.sh

RUN chmod 755 /*.sh

RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN cat /root/.ssh/id_rsa.pub
COPY pasquino/ssh-config /root/.ssh/config

# config to enable .htaccess
ADD apache/default.conf /etc/apache2/sites-available/000-default.conf
ADD apache/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
ADD apache/ports.conf /etc/apache2/ports.conf
RUN a2enmod rewrite
RUN a2enmod ssl

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 20M
ENV PHP_POST_MAX_SIZE 20M

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer --version

# Configure locales
RUN locale-gen en_US en_US.UTF-8
RUN locale-gen es_AR es_AR.UTF-8
RUN dpkg-reconfigure locales

COPY pasquino/data-sources.xml /var/www/app/conf/data-sources.xml

#Configure PHP.ini
RUN /configure-php.sh

ADD pasquino/init-pear.sh /init-pear.sh
RUN /init-pear.sh

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
WORKDIR /var/www/app
CMD ["/run.sh"]
