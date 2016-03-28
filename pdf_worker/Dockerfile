FROM php:7-cli

MAINTAINER Jean Traullé <jean@opencomp.fr>

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/www/html

ADD ./start_pdf_worker.sh /opt/start_pdf_worker.sh

RUN chmod u+x /opt/start_pdf_worker.sh

CMD /opt/start_pdf_worker.sh
