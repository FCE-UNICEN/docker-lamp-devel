FROM ubuntu:bionic as apache-php56
LABEL mantainer="Lucas Vidaguren <lucas.vidaguren@asivas.com.ar>"

# Install packages
RUN apt-get -qq update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install \
               curl \
               git \
               vim

RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN cat /root/.ssh/id_rsa.pub

ENV timezone=America/Argentina/Buenos_Aires

RUN ln -fs /usr/share/zoneinfo/${timezone} /etc/localtime
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata locales
RUN dpkg-reconfigure --frontend noninteractive tzdata


#https://github.com/lvidaguren/pthreads.git

RUN DEBIAN_FRONTEND=noninteractive apt -y -qq install software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get -qq update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install \
               supervisor \
               apache2 \
               pwgen

RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install \
               php5.6-mysql \
               php5.6-mcrypt \
               php5.6-gd \
               php5.6-curl \
               php5.6-xmlrpc \
               php5.6-intl \
               php5.6-tidy \
               php5.6-dev \
               php-gettext

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5.6-xdebug


RUN curl https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5


#Aplico new relic post instalación
#RUN ln -s /usr/lib/newrelic-php5/agent/x64/newrelic-20131226-zts.so /usr/lib/php5/20131226-zts/newrelic.so
RUN phpenmod newrelic

#RUN DEBIAN_FRONTEND=noninteractive apt install -y cifs-utils cups-client

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer --version

# Configure locales
RUN locale-gen en_US en_US.UTF-8
RUN locale-gen es_AR es_AR.UTF-8
RUN DEBIAN_FRONTEND="noninteractive" dpkg-reconfigure locales

# Timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Add image configuration and scripts
ADD apache/start-apache2.sh /start-apache2.sh
ADD apache/configure-php.sh /configure-php.sh

ADD run.sh /run.sh

ADD apache/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
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

RUN chmod 755 /*.sh

#Configure PHP.ini
RUN /configure-php.sh

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV workdir=/var/www/app

EXPOSE 80
WORKDIR ${workdir}
CMD ["/run.sh"]

#FROM pthreads as with-pear
FROM apache-php56 as with-pear

ADD pasquino/init-pear.sh /init-pear.sh

RUN chmod 755 /*.sh
RUN /init-pear.sh

FROM with-pear as pasquino
# Add Pasquino Install utils
ADD pasquino/get-pasquino.sh /init-pasquino.sh

# Add Pasquino app getter
ADD pasquino/init-app.sh /init-app.sh

COPY pasquino/ssh-config /root/.ssh/config

RUN chmod 755 /*.sh

RUN /init-pasquino.sh

RUN git config --global --add safe.directory ${workdir}

FROM pasquino as app

ADD pasquino/.env.app ${workdir}/.env

COPY pasquino/data-sources.xml /var/www/app/conf/data-sources.xml

ENV newrelic_application_name "LiClinica"
ENV newrelic_licence_key "5a0fab99b64e53e50c6168b8a7cf2f25e1bbNRAL"

RUN echo newrelic-php5 newrelic-php5/application-name string "${newrelic_application_name}" | debconf-set-selections && \
    echo newrelic-php5 newrelic-php5/license-key string "${newrelic_licence_key}" | debconf-set-selections \
    && \ dpkg-reconfigure --frontend noninteractive newrelic-php5

RUN /init-app.sh

#ENV CUPS_SERVER "192.168.82.14:631"
#ENV CUPS_USER "lucas"
