FROM php:8.3-fpm-alpine3.19

LABEL maintainer="Jean Traullé <jean@opencomp.fr>"

RUN apk -U upgrade \
    && apk add --no-cache \
            # For building/installing PECL redis PHP extension
            build-base autoconf \
            # For SimpleXML PHP extension
            libxml2 libxml2-dev \
            # For wkhtmltopdf runtime dependencies
            libzip-dev libstdc++ libx11 libxrender libxext libssl3 ca-certificates \
            # For GD PHP extension
            ttf-freefont ttf-dejavu freetype-dev libjpeg-turbo-dev libpng-dev \
            # For mbstring build
            oniguruma-dev \
            # For building/installing intl PHP extension
            icu-libs icu-dev \
            # For optimizing uploaded images (1)
            optipng gifsicle \
            # For PDO PGSQL driver
            postgresql-dev \
    # For optimizing uploaded images (2)
    # ! jpegoptim and pngquant are in community repo
    && apk add --no-cache \
               --repository http://dl-cdn.alpinelinux.org/alpine/v3.19/community/ \
               jpegoptim pngquant \
    # Install PHP extensions
    # -- mbstring intl simplexml are CakePHP requirements
    # -- pdo and pdo_mysql allow connection to MySQL using PHP Data Objects
    # -- zip allow read/write ZIP compressed archives
    && docker-php-ext-install mbstring intl simplexml mysqli pdo pdo_mysql pdo_pgsql zip \
    # Configure and install PHP GD extension
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && pecl install redis \
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

# Get wkhtmltopdf from surnet/alpine-wkhtmltopdf:3.19.0-0.12.6-small
# wkhtmltopdf with patched QT takes ~20m to compiles on i5
#
COPY --from=surnet/alpine-wkhtmltopdf:3.19.0-0.12.6-small /bin/wkhtmltopdf /usr/bin/wkhtmltopdf

CMD ["php-fpm"]
