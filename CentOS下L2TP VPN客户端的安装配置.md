# [CentOS下L2TP VPN客户端的安装配置](http://www.dianjingling.com/home/44.html)

本文为在`Linux`下搭建`VPN`客户端，协议使用`L2TP`，系统环境为`CentOS 7`，步骤如下：



\1. 安装客户端软件`xl2tpd`，`ppp`

```
[root@iZ23v2l73xvZ ~]# yum install -y xl2tpd ppp
```



\2. 配置`xl2tpd`

编辑 `/etc/xl2tpd/xl2tpd.conf` 文件，内容如下：

```
[lac bjvpn]
name = sun
lns = 60.191.127.190
pppoptfile = /etc/ppp/peers/bjvpn.l2tpd
ppp debug = no
```

参数说明：

```
bjvpn 连接名称，后面控制连接时需要
name vpn帐号的用名户，由vpn服务器分配
lns vpn服务器ip地址
pppoptfile 连接选项
```



\3. 配置连接选项

编辑 `/etc/ppp/peers/bjvpn.l2tpd` 文件，内容如下：

```
remotename bjvpn
user "sun"
password "pass"
unit 0
nodeflate
nobsdcomp
noauth
persist
nopcomp
noaccomp
maxfail 5
debug
```

参数说明：

```
remotename vpn名称
user vpn帐号用户名
password vpn帐号密码
```



4 启动

在命令行依次输入如下命令：

```
[root@iZ23v2l73xvZ ~]# xl2tpd
[root@iZ23v2l73xvZ ~]# echo 'c bjvpn' >/var/run/xl2tpd/l2tp-control
```

查看 `/var/log/messages` 中是否有异常。

如果一切正常，使用`ifconfig`查看`ppp0`是否已经启动。

```
[root@iZ23v2l73xvZ ~]# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
    inet 10.252.140.34 netmask 255.255.248.0 broadcast 10.252.143.255
    ether 00:16:3e:00:48:04 txqueuelen 1000 (Ethernet)
    RX packets 6272894717 bytes 450830441559 (419.8 GiB)
    RX errors 0 dropped 0 overruns 0 frame 0
    TX packets 4751780943 bytes 17514808533925 (15.9 TiB)
    TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
    inet 121.40.67.66 netmask 255.255.252.0 broadcast 121.40.67.255
    ether 00:16:3e:00:24:94 txqueuelen 1000 (Ethernet)
    RX packets 8059796 bytes 1101212197 (1.0 GiB)
    RX errors 0 dropped 0 overruns 0 frame 0
    TX packets 5073542 bytes 499312689 (476.1 MiB)
    TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING> mtu 65536
    inet 127.0.0.1 netmask 255.0.0.0
    loop txqueuelen 1 (Local Loopback)
    RX packets 31365 bytes 5216182 (4.9 MiB)
    RX errors 0 dropped 0 overruns 0 frame 0
    TX packets 31365 bytes 5216182 (4.9 MiB)
    TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0

ppp0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST> mtu 1500
    inet 10.252.140.34 netmask 255.255.255.255 destination 172.30.0.1
    ppp txqueuelen 3 (Point-to-Point Protocol)
    RX packets 18364 bytes 7805002 (7.4 MiB)
    RX errors 0 dropped 0 overruns 0 frame 0
    TX packets 26262 bytes 3489595 (3.3 MiB)
    TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
```

注意，这时可能还不能直接访问`vpn`服务端的内部其它网段的主机。如我在`vpn`服务端的`ip`为`192.168.20.53`，但是我要访问`192.168.8.0/24` 网络的主机。这就需要手动添加路由。比如`192.168.19.151`，我可以使用下面的命令：

```
[root@iZ23v2l73xvZ ~]# route add -host 192.168.19.151 dev ppp0
```

最后使用`ping`命令查看网络连接效果：

```
[root@iZ23v2l73xvZ ~]# ping 192.168.19.151
PING 192.168.19.151 (192.168.19.151) 56(84) bytes of data.
64 bytes from 192.168.19.151: icmp_seq=1 ttl=127 time=5.60 ms
64 bytes from 192.168.19.151: icmp_seq=2 ttl=127 time=5.55 ms
64 bytes from 192.168.19.151: icmp_seq=3 ttl=127 time=5.42 ms
64 bytes from 192.168.19.151: icmp_seq=4 ttl=127 time=5.40 ms
```



