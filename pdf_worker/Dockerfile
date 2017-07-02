FROM php:7.1-alpine

MAINTAINER Jean Traullé <jean@opencomp.fr>

	# Installation des paquets requis pour la compilation
	# des extensions PHP à installer
RUN 	apk add --no-cache --virtual .persistent-deps \
	autoconf \
	cyrus-sasl-dev \
	freetype-dev \
	icu-dev \
	libjpeg libjpeg-turbo-dev \
	libmemcached-dev \
	libpng-dev \
	make \
	git \
	g++ \
	zlib-dev && \
	apk add --update bash && \
	# Installation des extensions
    	docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    	docker-php-ext-configure intl && \
    	docker-php-ext-install gd pdo_mysql mbstring intl && \

    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
	
	# Installation de l'extension memcached depuis les sources
	mkdir /opt && \
	cd /opt && \
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
	
ADD ./start_pdf_worker.sh /opt/start_pdf_worker.sh

RUN chmod u+x /opt/start_pdf_worker.sh

CMD /bin/bash /opt/start_pdf_worker.sh
