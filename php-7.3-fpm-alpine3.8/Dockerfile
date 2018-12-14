FROM php:7.3-fpm-alpine3.8

MAINTAINER Jean Traullé <jean@opencomp.fr>

RUN apk add --no-cache \
            # For building/installing PECL redis PHP extension
            build-base autoconf \
            # For SimpleXML PHP extension
            libxml2 libxml2-dev \
            # For wkhtmltopdf runtime dependencies
            zlib glib openssl fontconfig freetype libx11 libxext libxrender \
            # For GD PHP extension
            ttf-freefont ttf-dejavu freetype-dev libjpeg-turbo-dev libpng-dev \
            # For installing composer dependencies
            git \
            # For building/installing intl PHP extension
            icu-libs icu-dev \
            # For optimizing uploaded images (1)
            optipng gifsicle \
    # For optimizing uploaded images (2)
    # ! jpegoptim and pngquant are in community repo
    && apk add --no-cache \
               --repository http://dl-cdn.alpinelinux.org/alpine/3.8/community/ \
               jpegoptim pngquant \
    # Install PHP extensions
    # -- mbstring intl simplexml are CakePHP requirements
    # -- pdo and pdo_mysql allow connection to MySQL using PHP Data Objects
    # -- zip allow read/write ZIP compressed archives
    && docker-php-ext-install mbstring intl simplexml pdo pdo_mysql zip \
    # Configure and install PHP GD extension
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require hirak/prestissimo \
    && pecl install redis-4.0.0 \
    && docker-php-ext-enable redis \
    # Uninstalling all required dev dependencies
    # used during compiling of PHP extensions.
    && apk del autoconf build-base freetype-dev icu-dev libjpeg-turbo-dev libpng-dev libxml2-dev \
    # Clearing package cache and temp directory
    && rm -rf /var/cache/apk/* /tmp/* \
    # Set recommended opcache PHP.ini settings
    # See https://secure.php.net/manual/en/opcache.installation.php
    && { \
    		echo 'opcache.memory_consumption=128'; \
    		echo 'opcache.interned_strings_buffer=8'; \
    		echo 'opcache.max_accelerated_files=4000'; \
    		echo 'opcache.revalidate_freq=60'; \
    		echo 'opcache.fast_shutdown=1'; \
    		echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf \
    && echo "expose_php=0" > /usr/local/etc/php/php.ini

# Get wkhtmltopdf from opencomp/wkhtmltopdf:0.12.4-alpine3.6
# wkhtmltopdf with patched QT takes ~20m to compiles on i5
#
# To reduce size of the image, wkhtmltopdf is built into a
# multi-stages build. The resulting binary is passed into a
# fresh alpine image and only required librairies needed
# to run wkhtmltopdf are installed
COPY --from=opencomp/wkhtmltopdf:0.12.4-alpine3.7 /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf

CMD ["php-fpm"]
