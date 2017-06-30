FROM	php:fpm-alpine

MAINTAINER Jean Traullé

# intl, zip, soap
# xml and curl are already bundled
RUN apk add --update --no-cache libintl icu icu-dev libxml2-dev \
    && docker-php-ext-install intl zip soap

# mysqli, pdo, pdo_mysql, pdo_pgsql
RUN docker-php-ext-install pdo pdo_mysql

# mcrypt, gd, iconv
RUN apk add --update --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd

# memcached
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

# set recommended opcache PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# set recommended apcu PHP.ini settings
# see https://secure.php.net/manual/en/apcu.configuration.php
RUN { \
        echo 'apc.shm_segments=1'; \
        echo 'apc.shm_size=256M'; \
        echo 'apc.num_files_hint=7000'; \
        echo 'apc.user_entries_hint=4096'; \
        echo 'apc.ttl=7200'; \
        echo 'apc.user_ttl=7200'; \
        echo 'apc.gc_ttl=3600'; \
        echo 'apc.max_file_size=1M'; \
        echo 'apc.stat=1'; \
} > /usr/local/etc/php/conf.d/apcu-recommended.ini

RUN sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf

RUN echo "expose_php=0" > /usr/local/etc/php/php.ini

# Clean up
RUN rm -rf /tmp/*

CMD ["php-fpm"]