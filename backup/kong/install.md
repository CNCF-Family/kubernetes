# 创建kong network
docker network create kong-net

# 安装PostgreSQL数据库
docker run -d --name kong-database \
               --network=kong-net \
               -v /www/kong-postgresql:/var/lib/postgresql/data \
               -p 5432:5432 \
               -e "POSTGRES_USER=kong" \
               -e "POSTGRES_DB=kong" \
               -e "POSTGRES_PASSWORD=kong" \
               postgres:9.6

# Prepare your database
# 创建临时kong连接pgsql迁移数据
docker run --rm \
     --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
     kong:latest kong migrations bootstrap

# start kong
docker run -d --name kong \
     --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
     -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
     -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
     -p 8000:8000 \
     -p 8443:8443 \
     -p 0.0.0.0:8001:8001 \
     -p 0.0.0.0:8444:8444 \
     kong:latest

------------------------------------------------------konga--------------------

# 初始化konga数据库
 docker run --rm pantsel/konga:latest -c prepare -a postgres -u postgresql://kong:kong@172.16.xx.xx:5432/konga

# 启动konga
 docker run -p 1337:1337 \
        --network kong-net \
        --name konga \
        -e "NODE_ENV=production"  \
        -e "DB_ADAPTER=postgres" \
        -e "DB_URI=postgresql://kong:kong@172.16.**.**:5432/konga" \
        -d pantsel/konga

# 安装pgadmin4
docker run -p 8009:80 \
    --name pgadmin \
    -e "PGADMIN_DEFAULT_EMAIL=denxxxxx10@gmail.com" \
    -e "PGADMIN_DEFAULT_PASSWORD=gevxxxxx610@1030" \
    -d dpage/pgadmin4
