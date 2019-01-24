FROM php:7.0-apache

MAINTAINER Hugo van Duijn <hugo.vanduijn@naturalis.nl>
LABEL Description="LAMP stack, modified for naturalis linnaeusng application." 

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 \
        && \
        /usr/bin/curl -sL https://deb.nodesource.com/setup_7.x | /bin/bash -  \
        && \
        apt-get install -y --no-install-recommends \
        git \
	    libbz2-dev \
	    libzip-dev \
        openssh-client \
        vim \
        locales-all \
        nodejs \
        && \
    pecl install xdebug \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install composer for PHP dependencies and create symlink for node to nodejs
RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer 


# install and activate php and apache modules
RUN docker-php-ext-install gettext mysqli bz2 zip opcache && \
    docker-php-ext-enable gettext mysqli bz2 zip opcache && \
    a2enmod rewrite

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
        echo 'opcache.enable=0'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# add files into container
ADD linnaeus_repo.key /root/.ssh/id_rsa
ADD config/php.ini /usr/local/etc/php/
ADD config/xdebug.ini /usr/local/etc/php/conf.d
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD config/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Add private key to id_rsa for github checkouts and clean html directory
RUN ssh-keyscan github.com > ~/.ssh/known_hosts && \
    chmod 0600 ~/.ssh/id_rsa

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
