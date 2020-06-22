FROM php:7.1-fpm

ENV PHP_HOME /epetphp

WORKDIR /epetphp

ADD sources.list sources.list

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && mv sources.list /etc/apt/ && \
    rm -Rf /var/lib/apt/lists/* && \
    apt-get update -y  && \
    apt install -y  --no-install-recommends \
        git \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        tzdata \
        libmhash2  \
        libmhash-dev  \
        libc-client-dev  \ 
        libkrb5-dev  \
        libmagickcore-dev  \
        libmagickwand-dev \
        locales
 
RUN docker-php-ext-install mcrypt mysqli pdo pdo_mysql

# install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# install the soap extension
RUN apt-get update -yqq && \
    apt-get -y install libxml2-dev && \
    docker-php-ext-install soap

#mongodb
RUN curl -fSL http://pecl.php.net/get/mongodb-1.5.3 -o mongodb-1.5.3.tgz && \
    mkdir /usr/src/php/ext/mongodb/ -p && \
    tar zxvf  mongodb-1.5.3.tgz -C /usr/src/php/ext/mongodb/ --strip-components 1

#redis
RUN curl -fSL http://pecl.php.net/get/redis-4.1.1 -o redis-4.1.1.tgz && \
    mkdir /usr/src/php/ext/redis/ -p && \
    tar zxvf  redis-4.1.1.tgz -C /usr/src/php/ext/redis/ --strip-components 1

# install bcmath, mbstring and zip extensions
RUN docker-php-ext-install bcmath && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip

# enable Exif PHP extentions requirements
RUN docker-php-ext-install exif

# tokenizer Modifications:
RUN docker-php-ext-install tokenizer

# install intl and requirements
RUN apt-get update -yqq && \
    apt-get install -y zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl

# LDAP:
RUN apt-get update -yqq && \
    apt-get install -y libldap2-dev && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

# curl extension
RUN apt-get install -y curl libcurl4-openssl-dev --no-install-recommends && \
    docker-php-ext-install curl

#imagick
RUN curl -fSL http://pecl.php.net/get/imagick-3.4.3.tgz  -o  imagick-3.4.3.tgz && \
mkdir /usr/src/php/ext/imagick/ -p && \
tar zxvf  imagick-3.4.3.tgz -C /usr/src/php/ext/imagick/ --strip-components 1

# ssh2 module
RUN apt-get install -y libssh2-1-dev && \
    pecl install ssh2-1.0 && \
    docker-php-ext-enable ssh2

# php-module: curl dom bz2 gd json mysqli pcntl pdo pdo_mysql phar posix
RUN apt-get install -y libxml2-dev libbz2-dev re2c libpng++-dev \
    libjpeg-dev libvpx-dev zlib1g-dev libgd-dev \
    libtidy-dev libxslt1-dev libmagic-dev libexif-dev file \
    sqlite3 libsqlite3-dev libxslt-dev

RUN export CFLAGS="-I/usr/src/php" && \
    docker-php-ext-install xmlreader xmlwriter

RUN docker-php-ext-configure json && \
    docker-php-ext-configure session && \
    docker-php-ext-configure ctype && \
    docker-php-ext-configure tokenizer && \
    docker-php-ext-configure simplexml && \
    docker-php-ext-configure dom && \
    docker-php-ext-configure mbstring && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure pdo && \
    docker-php-ext-configure pdo_sqlite && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-configure iconv && \
    docker-php-ext-configure xml && \
    docker-php-ext-configure phar

RUN docker-php-ext-install \
    dom \
    bz2 \
    json \
    pcntl \
    phar \
    posix \
    simplexml \
    soap \
    tidy \
    xml \
    xmlrpc \
    xsl \
    calendar \
    ctype \
    fileinfo \
    ftp \
    sysvmsg \
    sysvsem \
    sysvshm  \
    redis \
    mongodb  \
    imagick

# mhash
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN docker-php-ext-configure hash --with-mhash && \
    docker-php-ext-install hash

# Opcache
RUN docker-php-ext-install opcache

# set locale to utf-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install helpful libs
RUN apt-get -y install libfcgi0ldbl nano cron

# crontab fix: https://stackoverflow.com/questions/43323754/cannot-make-remove-an-entry-for-the-specified-session-cron
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/cron

# expose /status for health check & stop access log
RUN echo "pm.status_path = /status" >> /usr/local/etc/php/conf.d/zz-docker.conf && \
    echo "ping.path      = /ping"   >> /usr/local/etc/php/conf.d/zz-docker.conf && \
    echo "ping.response  = OK"      >> /usr/local/etc/php/conf.d/zz-docker.conf && \
    echo "access.log     = /proc/self/fd/1" >> /usr/local/etc/php/conf.d/zz-docker.conf  &&  \
    adduser  www 

COPY ./php.ini    /usr/local/etc/php/
COPY ./php-fpm.conf   /usr/local/etc/
COPY  ./nginx.tar.gz   /epetphp/

#设置变量
ENV NGINX_VERSION 1.16.0

#编译安装
RUN CONFIG="\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=www \
        --group=www \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
    " \
    && apt-get install  -y libpcre3 libpcre3-dev openssl libssl-dev libperl-dev procps  \
    && mkdir -p /usr/src \
    && mkdir -p /var/cache/nginx/client_temp \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm nginx.tar.gz \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG \
    && make \
    && make install 

COPY ./nginx.conf /etc/nginx/nginx.conf
# Clean up
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  /epetphp/*  /usr/src/*

CMD php-fpm && nginx

