导出整个数据库
pg_dump -h localhost -U postgres(用户名) 数据库名(缺省时同用户名)>/data/dum.sql
数据库名与“>”之间没有空格

导入整个数据库
使用如下命令需要先进入postgres权限:sudo su postgres
psql postgres(数据库名) 用户名(缺省时同数据库名)< /data/dum.sql
数据库名与“>”之间没有空格

导出某个表
pg_dump -h localhost -U postgres(用户名) 数据库名(缺省时同用户名) -t table(表名) >/data/dum.sql


导入之前导出的单个表的结构及数据
psql -h localhost -d 数据库名 -U 用户名 -f .sql文件


----------------------------------------------------------------------------------------------------
# 测服
pg_host = 172.16.**.**          # The PostgreSQL host to connect to.
pg_port = 5432                  # The port to connect to.
pg_user = kong                  # The username to authenticate if required.
pg_password = e××*k×××2019     # The password to authenticate if required.
pg_database = kong 

-----------------------------------------------------------------------------------------------------
# 生产
pg_host = 172.16.**.**           # The PostgreSQL host to connect to.
pg_port = 5432                  # The port to connect to.
pg_user = kong                  # The username to authenticate if required.
pg_password = e××*k×××2019      # The password to authenticate if required.
pg_database = kong 

### 导出
pg_dump -h 172.16.**.** -U kong kong>/tmp/kong_product.sql
### 导入
psql -h 172.16.**.** -d kong -U kong -f /tmp/kong_product.sql







