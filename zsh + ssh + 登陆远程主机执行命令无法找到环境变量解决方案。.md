# zsh + ssh + 登陆远程主机执行命令无法找到环境变量解决方案。



解决方法：

```
vim /etc/zshenv
```

配置环境变量就可以了。

或者加载 你配置环境变量的文件。

```
ssh root@host command 
属于 non-interactive + non-login 。
```

放上一篇非常好的文章，虽然只适用于 bash 和 sh 但是对我启发很大。

[ssh连接远程主机执行脚本的环境变量问题](https://feihu.me/blog/2014/env-problem-when-ssh-executing-command-on-remote/)

