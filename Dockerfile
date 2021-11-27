FROM ubuntu:trusty
LABEL mantainer="Lucas Vidaguren <lucas.vidaguren@asivas.com.ar>"

# Install packages
RUN apt-get -qq update

ENV timezone=America/Argentina/Buenos_Aires

RUN ln -fs /usr/share/zoneinfo/${timezone} /etc/localtime
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata


#https://github.com/lvidaguren/pthreads.git

RUN DEBIAN_FRONTEND=noninteractive apt -y -qq install software-properties-common && \
    add-apt-repository -y ppa:nhojohl/php5-zts && \
    apt-get -qq update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install \
               supervisor \
               apache2 \
               apache2-mpm-prefork \
               pwgen \
               libapache2-mod-php5

RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install \
               php5-mysql \
               php5-mcrypt \
               php5-gd \
               php5-curl \
               php5-xmlrpc \
               php5-intl \
               php5-tidy \
               php5-dev \
               php-gettext

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-xdebug

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
               curl \
               git \
               vim

RUN cd /usr/local/src/ && \
    git clone https://github.com/lvidaguren/pthreads.git && \
    cd pthreads/ && \
    git checkout PHP5 && \
    phpize && ./configure && make && make install && \
    echo extension=pthreads.so > /etc/php5/mods-available/pthreads.ini && \
    php5enmod pthreads

RUN curl https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list && \
    apt-get update && \
    echo newrelic-php5 newrelic-php5/application-name string "LiClinica" | debconf-set-selections && \
    echo newrelic-php5 newrelic-php5/license-key string "5a0fab99b64e53e50c6168b8a7cf2f25e1bbNRAL" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5 && \
    DEBIAN_FRONTEND=noninteractive apt install -y cifs-utils cups-client && \
    mkdir -p  /etc/cups/ && \
    echo  "ServerName 192.168.82.14:631" > /etc/cups/client.conf && \
    echo "User lucas" > /etc/cups/client.conf

RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN cat /root/.ssh/id_rsa.pub
COPY pasquino/ssh-config /root/.ssh/config

#Aplico new relic post instalación
RUN ln -s /usr/lib/newrelic-php5/agent/x64/newrelic-20131226-zts.so /usr/lib/php5/20131226-zts/newrelic.so

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer --version

# Configure locales
RUN locale-gen en_US en_US.UTF-8
RUN locale-gen es_AR es_AR.UTF-8
RUN dpkg-reconfigure locales

# Timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

ADD pasquino/init-pear.sh /init-pear.sh
RUN /init-pear.sh


# Add image configuration and scripts
ADD apache/start-apache2.sh /start-apache2.sh
ADD apache/configure-php.sh /configure-php.sh

ADD run.sh /run.sh

ADD apache/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# Add Pasquino Install utils
ADD pasquino/get-pasquino.sh /init-pasquino.sh

# Add Pasquino app getter
ADD pasquino/init-app.sh /init-app.sh
ENV workdir=/var/www/app
ADD pasquino/.env.app ${workdir}/.env


# config to enable .htaccess
ADD apache/default.conf /etc/apache2/sites-available/000-default.conf
ADD apache/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
ADD apache/ports.conf /etc/apache2/ports.conf
RUN a2enmod rewrite
RUN a2enmod ssl

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 20M
ENV PHP_POST_MAX_SIZE 20M
ENV PHP_MEMORY_LIMT 2048M
ENV PHP_ERROR_REPORTING "E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE"

ENV PHP_ALLOWED_MEMORY_SIZE 2048

COPY pasquino/data-sources.xml /var/www/app/conf/data-sources.xml

RUN chmod 755 /*.sh

#Configure PHP.ini
RUN /configure-php.sh

RUN /init-pasquino.sh

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
WORKDIR ${workdir}
CMD ["/run.sh"]
