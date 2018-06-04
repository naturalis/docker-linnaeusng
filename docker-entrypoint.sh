#!/bin/bash

# clone repository 
if ! [[ -e /var/www/html/.git ]] ; then

    rm -rf /var/www/html
    git clone -b $GIT_BRANCH --single-branch git@github.com:naturalis/linnaeus_ng.git /var/www/html

    # copy default configs and modify password based on environment variables
    /bin/cp /var/www/html/configuration/app/default-configuration.php /var/www/html/configuration/app/configuration.php
    /bin/cp /var/www/html/configuration/admin/default-configuration.php /var/www/html/configuration/admin/configuration.php
    /bin/sed -i -E "s/'password' => '.*/'password' => '$MYSQL_PASSWORD',/" /var/www/html/configuration/app/configuration.php
    /bin/sed -i -E "s/'user' => '.*/'user' => '$MYSQL_USER',/" /var/www/html/configuration/app/configuration.php
    /bin/sed -i -E "s/'host' => '.*/'host' => '$MYSQL_HOST',/" /var/www/html/configuration/app/configuration.php
    /bin/sed -i -E "s/'tablePrefix' => '.*/'tablePrefix' => '$TABLE_PREFIX',/" /var/www/html/configuration/app/configuration.php
    /bin/sed -i -E "s/'password' => '.*/'password' => '$MYSQL_PASSWORD',/" /var/www/html/configuration/admin/configuration.php
    /bin/sed -i -E "s/'user' => '.*/'user' => '$MYSQL_USER',/" /var/www/html/configuration/admin/configuration.php
    /bin/sed -i -E "s/'host' => '.*/'host' => '$MYSQL_HOST',/" /var/www/html/configuration/admin/configuration.php
    /bin/sed -i -E "s/'tablePrefix' => '.*/'tablePrefix' => '$TABLE_PREFIX',/" /var/www/html/configuration/admin/configuration.php

    # create dirs and Set permissions
    mkdir -p /var/www/html/www/admin/templates/templates_c
    mkdir -p /var/www/html/www/admin/templates/cache
    mkdir -p /var/www/html/www/app/templates/templates_c
    mkdir -p /var/www/html/www/app/templates/cache
    mkdir -p /var/www/html/www/shared/media/project
    mkdir -p /var/www/html/log
    chmod 777 -R /var/www/html/www/admin/templates/templates_c
    chmod 777 -R /var/www/html/www/admin/templates/cache
    chmod 777 -R /var/www/html/www/app/templates/templates_c
    chmod 777 -R /var/www/html/www/app/templates/cache
    chmod 777 -R /var/www/html/www/shared/media/project
    chmod 777 -R /var/www/html/log

    # run composer install
    cd /var/www/html
    /usr/local/bin/composer install

    # Install third party javascripts
    /usr/bin/npm install --global bower
    /usr/bin/bower install --allow-root
    /usr/bin/npm install --global gulp 
    /usr/bin/npm install
    /usr/bin/gulp

fi

# run server
/usr/sbin/apache2ctl -D FOREGROUND
