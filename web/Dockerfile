FROM ubuntu:trusty

MAINTAINER Jean Traullé <jean@opencomp.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen fr_FR.UTF-8  
ENV LANG=fr_FR.UTF-8 LANGUAGE=fr_FR:fr LC_ALL=fr_FR.UTF-8  

RUN apt-get update -qqy && \
    apt-get install -qqy software-properties-common python-software-properties && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:ondrej/php-7.0 && apt-get update -qqy && \
    apt-get install -qqy \
    nginx \
    php7.0-fpm \
    php7.0-common \
    php7.0-curl \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-sqlite \
    php7.0-opcache \
    php7.0-intl \
    curl \
    npm \
    git \
    sendmail && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i -e "s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.0/fpm/pool.d/www.conf && \
    find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

ADD ./nginx.conf /etc/nginx/sites-available/default.conf

RUN usermod -u 1000 www-data && \
    usermod -a -G users www-data && \
    rm -Rf /etc/nginx/conf.d/* && \
    rm -Rf /etc/nginx/sites-available/default && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www && \
    mkdir /run/php && chown www-data:www-data -R /run/php && \
    npm install --global bower && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --version

WORKDIR /var/www/html

EXPOSE 80

CMD /usr/sbin/php-fpm7.0 -D && /usr/sbin/nginx