# [centos crontab详解](https://www.cnblogs.com/tiandi/p/7147031.html)

**1、crontab安装**

```
[root@CentOS ~]# yum install vixie-cron
[root@CentOS ~]# yum install crontabs
```

说明：
vixie-cron软件包是cron的主程序；
crontabs软件包是用来安装、卸装、或列举用来驱动 cron 守护进程的表格的程序。
cron 是linux的内置服务，但它不自动起来，可以用以下的方法启动、关闭这个服务：

```
/sbin/service crond start //启动服务
/sbin/service crond stop //关闭服务
/sbin/service crond restart //重启服务
/sbin/service crond reload //重新载入配置
```

查看crontab服务状态：service crond status

手动启动crontab服务：service crond start

**2、crontab基本格式**



```
# +---------------- minute  分钟(0 - 59)
# |  +------------- hour    小时(0 - 23)
# |  |  +---------- day     日期(1 - 31)
# |  |  |  +------- month   月份(1 - 12)
# |  |  |  |  +---- week    星期(0 - 7) (星期天=0 or 7)
# |  |  |  |  |
# *  *  *  *  *  要运行的命令
```



**3、crontab命令编辑**

```
crontab -u //设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数
crontab -l //列出某个用户cron服务的详细内容 　　 
crontab -r //删除没个用户的cron服务 　　 
crontab -e //编辑某个用户的cron服务
```

（1）新建一个定时器，（普通用户的定时器，在普通用户下自己建）

crontab -e //先su切换到某个用户下，然后输入这个命令，然后进入编辑状态
然后输入定时器语句如下：（>>是把echo输出字符串打印到text.txt文件中）
0 6 * * * echo "Good morning." >> /tmp/test.txt

（2）root查看自己的cron设置：

```
crontab -u root -l
```

（3）root想删除fred用户的cron设置：

```
crontab -u fred -r
```

**4、常用示例**



```ABAP
每天早上6点追加一条字符串到一个文本。
0 6 * * * echo "Good morning." >> /tmp/test.txt

每两个小时追加一条字符串一个文本。
0 */2 * * * echo "Have a break now." >> /tmp/test.txt

晚上11点到早上8点之间每两个小时，早上八点
0 23-7/2，8 * * * echo "Have a good dream：）" >> /tmp/test.txt

每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点
0 11 4 * 1-3 command line

1月1日早上4点
0 4 1 1 * command line

每月每天每小时的第 0 分钟执行一次 /bin/ls
0 * * * * /bin/ls

在 12 月内, 每天的早上 6 点到 12 点中，每隔 20 分钟执行一次 /usr/bin/backup
*/20 6-12 * 12 * /usr/bin/backup

周一到周五每天下午 5:00 寄一封信给 alex_mail_name :
0 17 * * 1-5 mail -s "hi" alex_mail_name < /tmp/maildata

每月每天的午夜 0 点 20 分, 2 点 20 分, 4 点 20 分....执行 echo "haha"
20 0-23/2 * * * echo "haha"

晚上11点到早上8点之间每两个小时，早上8点,显示时间
0 23-7/2，8 * * * date
```



```
每次编辑完某个用户的cron设置后， cron自动在/var/spool/cron下生成一个与此用户同名的文件，此用户的cron信息都记录在这个文件中，这个文件是不可以直接编辑的， 只可以用crontab -e 来编辑。cron启动后每过一份钟读一次这个文件，检查是否要执行里面的命令。因此此文件修改后不需要重新启动cron服务。
```