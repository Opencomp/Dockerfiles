FROM opencomp/php:7.4-fpm-alpine3.11

LABEL maintainer="Jean Traullé <jean@opencomp.fr>"

RUN apk add --no-cache \
            # For building php extensions
            autoconf build-base \
            # For installing composer dependencies
            yarn \
            git \
            # For panther testing
            chromium \
            chromium-chromedriver \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require hirak/prestissimo \
    && pecl install pcov \
    && docker-php-ext-enable pcov \
    # Uninstalling all required dev dependencies
    # used during compiling of PHP extensions.
    && apk del autoconf build-base \
    # Clearing package cache and temp directory
    && rm -rf /var/cache/apk/* /tmp/*

ENV TMPDIR /var/www/html/tmp
ENV PANTHER_CHROME_DRIVER_BINARY /usr/lib/chromium/chromedriver
ENV PANTHER_CHROME_BINARY /usr/bin/chromium-browser
ENV PANTHER_NO_SANDBOX 1
