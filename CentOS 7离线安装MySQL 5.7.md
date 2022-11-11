# CentOS 7离线安装MySQL 5.7 

https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html

```
yum install libaio # install library
```



```css
[client]                                       # 客户端设置，即客户端默认的连接参数
port = 3306                                    # 默认连接端口
socket = /home/mysql/3306/tmp/mysql.sock       # 用于本地连接的socket套接字，mysqld守护进程生成了这个文件

[mysqld] 
server-id=47 
#开启binlog 主从复制设置
log_bin=master-bin 
log_bin-index=master-bin.index 

skip_name_resolve = 1                           # 只能用IP地址检查客户端的登录，不用主机名
basedir = /usr/local/mysql                      # MySQL安装根目录
datadir = /home/mysql/3306/data                 # MySQL数据文件所在位置
tmpdir  = /home/mysql/3306/tmp                  # 临时目录，比如load data infile会用到
socket = /home/mysql/3306/tmp/mysql.sock        # 为MySQL客户端程序和服务器之间的本地通讯指定一个套接字文件
pid-file = /home/mysql/3306/log/mysql.pid       # pid文件所在目录
character-set-server = utf8mb4                  # 数据库默认字符集,主流字符集支持一些特殊表情符号（特殊表情符占用4个字节）
transaction_isolation = READ-COMMITTED          # 事务隔离级别，默认为可重复读，MySQL默认可重复读级别
collation-server = utf8mb4_general_ci           # 数据库字符集对应一些排序等规则，注意要和character-set-server对应
init_connect='SET NAMES utf8mb4'                # 设置client连接mysql时的字符集,防止乱码
lower_case_table_names = 1                      # 是否对sql语句大小写敏感，1表示不敏感
max_connections = 1000                          # 最大连接数
max_connect_errors = 100                        # 最大错误连接数
explicit_defaults_for_timestamp = OFF           # TIMESTAMP如果没有显示声明NOT NULL，允许NULL值

default-storage-engine=INNODB  					# 创建新表时将使用的默认存储引擎
default_authentication_plugin=mysql_native_password  # 默认使用“mysql_native_password”插件认证

# 日志设置
log_error = /home/mysql/3306/log/error.log      # 数据库错误日志文件
slow_query_log = 1                              # 慢查询sql日志设置
long_query_time = 1                             # 慢查询时间；超过1秒则为慢查询
slow_query_log_file = /home/mysql/3306/log/slow.log                  # 慢查询日志文件
log_queries_not_using_indexes = 1               # 检查未使用到索引的sql
log_throttle_queries_not_using_indexes = 5      # 用来表示每分钟允许记录到slow log的且未使用索引的SQL语句次数。该值默认为0，表示没有限制
min_examined_row_limit = 100                    # 检索的行数必须达到此值才可被记为慢查询，查询检查返回少于该参数指定行的SQL不被记录到慢查询日志
expire_logs_days = 5                            # MySQL binlog日志文件保存的过期时间，过期后自动删除
```

安装数据库

```shell
# 初始化数据库，并指定启动mysql的用户``
./mysqld --initialize --user=mysql
```

这里最好指定启动mysql的用户名，否则就会在启动MySQL时出现权限不足的问题

安装完成后，在my.cnf中配置的datadir目录下生成一个error.log文件，里面记录了root用户的随机密码。

```ABAP
cat error.log               
2021-12-09T07:49:36.859021Z 0 [Warning] [MY-011068] [Server] The syntax 'expire-logs-days' is deprecated and will be removed in a future release. Please use binlog_expire_logs_seconds instead.
2021-12-09T07:49:36.859572Z 0 [Warning] [MY-010086] [Server] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2021-12-09T07:49:36.861690Z 0 [System] [MY-013169] [Server] /usr/local/mysql-8.0.20-el7-x86_64/bin/mysqld (mysqld 8.0.20) initializing of server in progress as process 7418
2021-12-09T07:49:37.067038Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2021-12-09T07:49:44.255714Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2021-12-09T07:50:01.154887Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: PBX*5CHwqMds


A temporary password is generated for root@localhost: dilQtPXkg9_f

 root@localhost: igMQ&k5M7Y=L
```



登陆，修改密码

```shell
# 登陆mysql
mysql -uroot -p
# 修改root用户密码
set password for root@localhost=password("123456");


alter user user() identified by "XXXXXX";
```

>上面XXX代表你需要设置的密码是多少
>
>alter user user() identified by "XXXXXX";
>
>```mysql
>alter user user() identified by "123456";
>```



如果要为每个具体的用户账户设置单独的特定值，可以使用以下命令完成（注意：此命令会覆盖全局策略），单位是“天”，命令如下：

```mysql
ALTER USER ‘xiaoming’@‘localhost' PASSWORD EXPIRE INTERVAL 250 DAY;
```

如果让用户恢复默认策略，命令如下：

```mysql
ALTER USER 'xiaoming'@'localhost' PASSWORD EXPIRE DEFAULT;
```

个别使用者为了后期麻烦，会将密码过期功能禁用，命令如下：

```mysql
ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;
```

```mysql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```



3.执行下面语句添加权限

```mysql
use mysql;

select host, user, authentication_string, plugin from user;

#查看user表的root用户Host字段是localhost，说明root用户只能本地登录，现在把他改成远程登录

update user set host='%' where user='root';

#4.刷新权限

#所有操作后，应执行

FLUSH PRIVILEGES;
```



### 修改mysql加密规则

 

```mysql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

## 加密规则改了也同样设置密码
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '新的密码';

```



```mysql
CHANGE MASTER TO 
MASTER_HOST='192.168.0.34',
MASTER_PORT=3306, 
MASTER_USER='root', 
MASTER_PASSWORD='123456', 
MASTER_LOG_FILE='master-bin.000002', 
MASTER_LOG_POS=2170, 
GET_MASTER_PUBLIC_KEY=1;

#开启slave 
start slave; 
#查看主从同步状态 
show slave status; 
#或者用 
show slave status \G; #这样查看比较简洁
```

