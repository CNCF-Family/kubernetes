### 查看postgresql状态
systemctl status postgresql-9.6

/var/lib/pgsql/9.6/data/ 是postgresql数据目录

### kong启动
/usr/local/bin/kong start -c /etc/kong/kong.conf





------------------------------------------------------
### kong

安装包下载和官网示列：https://getkong.org/install/centos/

安装前先安装PostgreSQL

```
yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum install postgresql96-server postgresql96-contrib
```
**初始化数据库**
```
/usr/pgsql-9.6/bin/postgresql96-setup initdb
```

**修改配置**

```
vi /var/lib/pgsql/9.6/data/pg_hba.conf
```
注意这里两个地方都需要设置成 **trust**
```
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust

```

**创建kong数据库和用户权限**

```
sudo -i -u postgres
psql
CREATE USER kong; CREATE DATABASE kong OWNER kong;
```


**安装启动Kong**

```
sudo yum install epel-release
##需要提前下载安装包在当前目录
sudo yum install kong-community-edition-0.11.2.*.noarch.rpm --nogpgcheck
kong migrations up  -c /etc/kong/kong.conf
kong start -c /etc/kong/kong.conf
```


##kong-dashboard
kong-dashboard的安装很简单  
启动稍微记录一下

```
# Install Kong Dashboard
npm install -g kong-dashboard

# Start Kong Dashboard
kong-dashboard start --kong-url http://kong:8001

# Start Kong Dashboard on a custom port
kong-dashboard start \
  --kong-url http://kong:8001 \
  --port [port]

# Start Kong Dashboard with basic auth
kong-dashboard start \
  --kong-url http://kong:8001 \
  --basic-auth user1=password1 user2=password2

# See full list of start options
kong-dashboard start --help
```
我们实际的启动命令如下：  
```
kong-dashboard start \
  --kong-url http://127.0.0.1:8001 \
  --basic-auth user1=root root=etxxxxxx --port 80
```
 
 也有**使用docker启动**的  
 注意因为kong默认限制只能本地访问所以需要修改`/etc/kong/kong.conf`  
 我更推荐docker启动，简单高效没烦恼  
 docker 启动命令如下
 ```
 docker run --rm -p 80:8080 pgbi/kong-dashboard start \
  --kong-url http://{服务器内网ip}:8001
  --basic-auth root=et^%$#@!
 ```