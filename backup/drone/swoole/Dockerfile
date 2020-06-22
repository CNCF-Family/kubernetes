FROM registry.cn-hangzhou.aliyuncs.com/epet/epet_swoole:4.4.7  

COPY ./ $PHP_HOME

RUN composer update -v --no-dev && rm -rf .git

CMD ["php", "bin/server", "start"]