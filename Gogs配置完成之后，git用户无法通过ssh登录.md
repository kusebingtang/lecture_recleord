# Gogs配置完成之后，git用户无法通过ssh登录

 发表于 2016-10-27 17:09:06 | 更新于 2018-07-16 21:20:13 | 分类于 [Linux](https://tedxiong.com/categories/Linux/)

## 错误：

Gogs配置完成之后，如果git用户采用ssh登录服务器时，会报如下错误信息：

```
ted@TeddeMacBook-Pro  ~  ssh git@tedxiong.com
PTY allocation request failed on channel 0
Hi there, You've successfully authenticated, but Gogs does not provide shell access.
If this is unexpected, please log in with password and setup Gogs under another user.
Connection to tedxiong.com closed.
```

## 原因：

针对Gogs配置的SSH密钥被Gogs增加了特殊处理，密钥内容之前添加了command，不能再提供给Git用户使用。

```
command="/home/git/gogs/gogs serv key-5 --config='/home/git/gogs/custom/conf/app.ini'",
no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDg5y31Gcqr9z0Uf71NBAcD4jtYeETkOWGQ77DGxAX9UUKDKe
AhkFqJ6+MCcUza4R+bCatJbLZcMpIS6R4KqY1WXdl2XNdiRjuG41esde5TBiwbOdBLlj1u1kaLSSLOMe25PKUej
FLiEfv3NbNXAutl0ttIPKkAwwaW7hWPkWWOaOspB9Spnn5BT3cF319cs+41yr6aOnE1CY0OcQGALwlteSs90zoQ
5a0yjNKkQK5JL2Jrg3OtmhAuIq61yXmTBUmrnpOQehxT1AwAF6tES6/TBsSewa8k3sUwT/KwsS63NfVrHEyb5QE
wsSmYjCGKVB9Ly1W6to3zEGda/tkX+jT ted@TeddeMBP.lan
```

## 方案：

采用双ssh密钥，在客户端进行配置，针对不同的ssh连接采用不同的密钥。

## 操作：

1. Mac平台下，进入`~/.ssh`目录，之前肯定有了一对密钥，公钥`id_rsa.pub`和私钥`id_rsa`。

2. 使用命令生成新的一对密钥，切记要命名跟原来的密钥不同，`ssh-keygen -t rsa -f id_rsa_git -C "xiong-wei@hotmail.com"`

3. 在.ssh目录中创建config文件，然后添加如下内容：

   ```
   Host gogs.yourdomain.com
   IdentityFile ~/.ssh/gogs_id_rsa
   IdentitiesOnly yes
   Host yourdomain.com
   IdentityFile   ~/.ssh/id_rsa IdentitiesOnly yes
   ```

4. 完成