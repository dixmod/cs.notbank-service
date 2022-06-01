FROM php:8.0.1-fpm-alpine3.13

# configs


RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache

RUN \
    sed -i 's/pm.max_children = 5/pm.max_children = 16/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.start_servers = 2/pm.start_servers = 2/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 2/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 7/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 60s/' /usr/local/etc/php-fpm.d/www.conf && \
    \
    cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;realpath_cache_size.\+/realpath_cache_size = 4096K/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;realpath_cache_ttl.\+/realpath_cache_ttl = 600/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.enable=.\+/opcache.enable = 1/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.enable_cli=.\+/opcache.enable_cli = 1/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.memory_consumption=.\+/opcache.memory_consumption = 256/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.max_accelerated_files=.\+/opcache.max_accelerated_files = 40000/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.validate_timestamps=.\+/opcache.validate_timestamps = 1/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.revalidate_freq=.\+/opcache.revalidate_freq = 0/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.max_wasted_percentage=.\+/opcache.max_wasted_percentage = 10/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/;opcache.interned_strings_buffer=.\+/opcache.interned_strings_buffer = 16/' "$PHP_INI_DIR/php.ini" && \
    sed -i 's/post_max_size =.\+/post_max_size = 32M/' "$PHP_INI_DIR/php.ini"


ARG WORKDIR
ARG WORKUSER=www-data
ARG WORKUSER_HOME=/home/${WORKUSER}

RUN apk add protoc

# pull source


#ARG REPO_URL
ARG REPO_BRANCH
ARG REPO_USER
ARG REPO_PWD

RUN apk update \
    && apk add git \
    && apk add libzip-dev zip \
    && docker-php-ext-install zip \
    && curl -s https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir -p ${WORKDIR}  \
    && chown ${WORKUSER}:${WORKUSER} ${WORKDIR} \
    && chmod 0700 ${WORKDIR} \
    && repo_host=$(echo $REPO_URL | cut -d'/' -f3) \
    && repo_auth_url=$(php -r 'print str_replace("://", "://".urlencode($argv[2]).":".urlencode($argv[3])."@", $argv[1]);' $REPO_URL $REPO_USER $REPO_PWD) \
    && su - ${WORKUSER} -s /bin/sh -c "\
       mkdir /tmp/repo \
       && git clone --branch ${REPO_BRANCH} --depth 1 ${repo_auth_url} /tmp/repo \
       && cd /tmp/repo \
       && git archive ${REPO_BRANCH} | tar -x -C ${WORKDIR} \
       && rm -rf /tmp/repo \
       && mkdir ${WORKUSER_HOME}/.composer \
    " \
    && printf '{"http-basic": {"%s": {"username": "%s", "password": "%s"}}}' \
        ${repo_host} ${REPO_USER} ${REPO_PWD} > ${WORKUSER_HOME}/.composer/auth.json \
    && su - ${WORKUSER} -s /bin/sh -c "\
       cd ${WORKDIR} \
       && composer install --no-interaction --no-dev --optimize-autoloader --classmap-authoritative \
    " \
    && rm -rf ${WORKUSER_HOME}/.composer \
    && rm /usr/local/bin/composer \
    && apk del git \
    && rm -rf /var/lib/apt/lists/*


RUN apk add --no-cache postgresql-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install bcmath

WORKDIR $WORKDIR
