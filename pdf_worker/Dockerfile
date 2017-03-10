FROM php:7-cli

MAINTAINER Jean Traullé <jean@opencomp.fr>

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmemcached-dev \
	libpng12-dev \
        zlib1g-dev \
        libicu-dev \
	git \
        g++ \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl

# On clone l'extension php me   mcached depuis les sources et on la compile
# la version dans les dépôts Ubuntu présente un bug qui empêche d'utiliser
# memcached comme backend pour le stockage des données de session PHP.
RUN cd /opt && \
    git clone https://github.com/php-memcached-dev/php-memcached && \
    cd php-memcached && \
    git checkout -b php7 origin/php7 && \
    /usr/local/bin/phpize && \
    ./configure --with-php-config=/usr/local/bin/php-config && \
    make && \
    make install && \
    echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20-memcached.ini && \
    cd .. && \
    rm -rf php-memcached/

# On fait le ménage pour alléger le poids de l'image
RUN apt-get autoremove -qqy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD ./start_pdf_worker.sh /opt/start_pdf_worker.sh

RUN chmod u+x /opt/start_pdf_worker.sh

CMD /opt/start_pdf_worker.sh
