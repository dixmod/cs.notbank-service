
# base image
include(Dockerfile.m4)

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

RUN deluser www-data && adduser -DH -h /home/www-data -s /sbin/nologin -u 1000 www-data \
    && chown www-data:www-data ${WORKDIR}/web
