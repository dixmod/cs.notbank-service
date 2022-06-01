FROM php:8.0.1-fpm-alpine3.13

# configs

include(/var/www/docker/_recipes/PhpFpmConfig_Cold.dockerfile)

ARG WORKDIR
ARG WORKUSER=www-data
ARG WORKUSER_HOME=/home/${WORKUSER}

RUN apk add protoc

# pull source

include(/var/www/docker/_recipes/PullSource-php-7.4.alpine.dockerfile)

RUN apk add --no-cache postgresql-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql
    && docker-php-ext-install bcmath

WORKDIR $WORKDIR
