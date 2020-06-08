#!/bin/sh

# swoole-tracker安装

#tracker_dir='/usr/local/lib/php/extensions/swoole-tracker'
#cd $tracker_dir && ./deploy_env.sh
#printf '#!/bin/sh\n/opt/swoole/script/php/swoole_php /opt/swoole/node-agent/src/node.php &' > /opt/swoole/entrypoint.sh && \
#chmod 755 /opt/swoole/entrypoint.sh
#cat >> /usr/local/etc/php/conf.d/swoole-tracker.ini <<EOF
#extension=${tracker_dir}/swoole_tracker74.so 
#apm.enable=1
#apm.sampling_rate=100
#apm.enable_memcheck=1
#EOF

#name='sdebug'
#echo "download  $name"
#curl -fSL https://github.com/mabu233/sdebug/archive/sdebug_2_7.zip -o $name.zip
#mkdir /usr/src/php/ext/ -p
#unzip  $name.zip -d /usr/src/php/ext/

name='swoole-4.4.7'
echo "download  $name"
curl -fSL http://pecl.php.net/get/$name -o $name.tgz
mkdir /usr/src/php/ext/swoole/ -p
tar zxvf  $name.tgz -C /usr/src/php/ext/swoole/ --strip-components 1

name='mongodb-1.5.3'
echo "download  $name"
curl -fSL http://pecl.php.net/get/$name -o $name.tgz
mkdir /usr/src/php/ext/mongodb/ -p
tar zxvf  $name.tgz -C /usr/src/php/ext/mongodb/ --strip-components 1


name='redis-4.1.1'
echo "download  $name"
curl -fSL http://pecl.php.net/get/$name -o $name.tgz
mkdir /usr/src/php/ext/redis/ -p
tar zxvf  $name.tgz -C /usr/src/php/ext/redis/ --strip-components 1

name='SPL_Types'
echo "download  $name"
curl -fSL https://github.com/esminis/php_pecl_spl_types/archive/RELEASE_0_5_2.tar.gz -o $name.tar.gz
mkdir /usr/src/php/ext/$name/ -p
tar zxvf  $name.tar.gz -C /usr/src/php/ext/$name/ --strip-components 1

name='imagick-3.4.3'
curl -fSL http://pecl.php.net/get/$name.tgz -o $name.tgz
echo "download  $name"
mkdir /usr/src/php/ext/imagick/ -p
tar zxvf  $name.tgz -C /usr/src/php/ext/imagick/ --strip-components 1

name='ast-1.0.1'
curl -fSL http://pecl.php.net/get/$name.tgz -o $name.tgz
echo "download  $name"
mkdir /usr/src/php/ext/ast/ -p
tar zxvf  $name.tgz -C /usr/src/php/ext/ast/ --strip-components 1

name='zip-1.17.0'
curl -fSL http://pecl.php.net/get/$name.tgz -o $name.tgz
echo "download  $name"
mkdir /usr/src/php/ext/zip/ -p
tar zxvf  $name.tgz -C /usr/src/php/ext/zip/ --strip-components 1

apk update && apk add --no-cache libmcrypt-dev tzdata pcre pcre-dev libstdc++ openssl openssl-dev  openssh git  composer imagemagick  imagemagick-dev libpng  libpng-dev gcc make autoconf libc-dev libzip-dev libxml2-dev


docker-php-ext-configure swoole --enable-openssl
#docker-php-ext-configure sdebug-sdebug_2_7 --enable-xdebug

docker-php-ext-install redis mongodb swoole pdo_mysql  bcmath SPL_Types sockets  imagick  gd zip ast opcache soap zip  #sdebug-sdebug_2_7

# 修改UTC时间
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#指定opcache参数
cat >> /usr/local/etc/php/php.ini <<EOF
memory_limit = 256M
date.timezone = Asia/shanghai

[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=528
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=1
opcache.fast_shutdown=1
EOF

apk del tzdata libaio-dev autoconf build-base linux-headers tzdata libpng-dev
rm -rf /var/cache/apk/*
rm -rf /usr/src/php/*
rm -rf /tmp/*
rm -rf /$PHP_HOME/*