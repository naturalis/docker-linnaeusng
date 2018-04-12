FROM php:7.0-apache

MAINTAINER Hugo van Duijn <hugo.vanduijn@naturalis.nl>
LABEL Description="LAMP stack, based on Ubuntu 16.04 LTS. modified for naturalis linnaeusng application." 

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        openssh-client \
        vim
RUN pecl install xdebug
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install and activate php and apache modules
RUN docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli && \
    a2enmod rewrite

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
