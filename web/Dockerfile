FROM ubuntu:xenial

MAINTAINER Jean Traullé <jean@opencomp.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen fr_FR.UTF-8  
ENV LANG=fr_FR.UTF-8 LANGUAGE=fr_FR:fr LC_ALL=fr_FR.UTF-8

RUN apt-get update -qqy && \
    apt-get install -qqy \
    curl \
    freetype* \
    git \
    libmemcached-dev \
    nginx \
    npm \
    php-common \
    php-curl \
    php-dev \
    php-fpm \
    php-gd \
    php-intl \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-opcache \
    php-sqlite3 \
    php-xml \
    php-zip \
    pkg-config

# On clone l'extension php me   mcached depuis les sources et on la compile
# la version dans les dépôts Ubuntu présente un bug qui empêche d'utiliser
# memcached comme backend pour le stockage des données de session PHP.
RUN cd /opt && \
    git clone https://github.com/php-memcached-dev/php-memcached && \
    cd php-memcached && \
    git checkout -b php7 origin/php7 && \
    /usr/bin/phpize && \
    ./configure --with-php-config=/usr/bin/php-config && \
    make && \
    make install && \
    echo "extension=memcached.so" > /etc/php/7.0/fpm/conf.d/20-memcached.ini && \
    cd .. && \
    rm -rf php-memcached/

# On fait le ménage pour alléger le poids de l'image
RUN apt-get remove -qqy php-dev pkg-config && \
    apt-get autoremove -qqy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Modification des paramètres par défaut de nginx, php-fpm
RUN sed -i -e "s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf && \
    sed -i -e "s/user www-data;/#user www-data;/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \

    # Modfication des paramètres de PHP
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/session.save_handler = files/session.save_handler = memcached/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;session.save_path = .*/session.save_path = \"memcached:11211\"/g" /etc/php/7.0/fpm/php.ini && \

    # Modfication des paramètres de php-fpm
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \

    # Modfication des paramètres du pool www de php-fpm
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    echo 'env[DATABASE_URL] = $DATABASE_URL' >> /etc/php/7.0/fpm/pool.d/www.conf && \
    find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

ADD ./nginx.conf /etc/nginx/sites-available/default.conf

RUN usermod -u 1000 www-data && \
    usermod -a -G users www-data && \
    touch /var/log/php7.0-fpm.log && \
    touch /run/nginx.pid && \
    rm -Rf /etc/nginx/conf.d/* && \
    rm -Rf /etc/nginx/sites-available/default && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www && \
    chown www-data:www-data /var/log/php7.0-fpm.log && \
    chown www-data:www-data /var/lib/nginx && \
    chown www-data:www-data /var/log/nginx && \
    chown www-data:www-data /run/nginx.pid && \
    mkdir /run/php && chown www-data:www-data -R /run/php && \
    npm install --global bower && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER www-data

WORKDIR /var/www/html

EXPOSE 8080

CMD /usr/sbin/php-fpm7.0 -D && composer -n install && bower install --config.interactive=false  && /usr/sbin/nginx
