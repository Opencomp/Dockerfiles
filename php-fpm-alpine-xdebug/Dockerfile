FROM opencomp/php:7.2-fpm-alpine3.7

MAINTAINER Jean Traullé <jean@opencomp.fr>

RUN apk add --no-cache $PHPIZE_DEPS \
        && pecl install xdebug \
        && docker-php-ext-enable xdebug

CMD ["php-fpm"]
