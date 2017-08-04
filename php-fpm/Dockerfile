FROM php:fpm

MAINTAINER Jean Traullé

RUN apt-get update && apt-get install -y \
        # Gestion des polices avec GD
        freetype* \
        libfontconfig1 \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        # Pour cloner avec composer si nécessaire
        git \
        # Pour construire la lib memcached
        libmemcached-dev \
        # Pour wkhtmltopdf
        libxrender1 \
        libmcrypt-dev \
        # Pour intl
        libicu-dev \
	# Pour l'optimisation des images
	advancecomp pngcrush gifsicle jpegoptim libjpeg-progs imagemagick pngnq libpng-dev optipng pngquant\
    && docker-php-ext-install -j$(nproc) iconv mcrypt intl pdo pdo_mysql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get autoremove -qqy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install memcached-3.0.3 \
    && docker-php-ext-enable memcached \
    && rm -rf /tmp/*

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

RUN sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf

RUN echo "expose_php=0" > /usr/local/etc/php/php.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
