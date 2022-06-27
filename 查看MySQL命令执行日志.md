## 查看MySQL命令执行日志

### 1.开启日志记录

```sql
mysql> set global general_log=on;
```

### 2.查看日志文件状态和路径

```sql
mysql> show variables like "%general_log%";
+------------------+---------------------------------+
| Variable_name    | Value                           |
+------------------+---------------------------------+
| general_log      | ON                              |
| general_log_file | /var/lib/mysql/189f1c4189f7.log |
+------------------+---------------------------------+

```

### 3.查看日志

```sh
$ cat /var/lib/mysql/189f1c4189f7.log
```

