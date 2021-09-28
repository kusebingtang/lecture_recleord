[最新版Harbor搭建（harbor-offline-installer-v1.10.1.tgz）](https://www.cnblogs.com/leozhanggg/p/12554399.html)

 

**[Harbor](https://goharbor.io/)** 是一个开源镜像仓库，可通过基于角色的访问控制来保护镜像，新版本的Harbor还增加了扫描镜像中的漏洞并将镜像签名为受信任。

作为CNCF孵化项目，Harbor提供合规性，性能和互操作性，以帮助你跨Kubernetes和Docker等云原生计算平台持续，安全地管理镜像。

Harbor组件均以Docker容器方式启动，因此，你可以将其部署在任何支持Docker的Linux发行版上。

 ![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324081656648-789520421.png)

 

# 特性

> **☆ 易于部署：**可通过Docker compose或Helm Chart 部署 Harbor。
>
> ***\*☆\** 云原生注册表：**Harbor 支持容器镜像和Helm图表，可作为容器原生运行时和编排平台等云原生环境的注册表。
>
> ***\*☆\** 基于角色控制：**用户通过项目访问不同的存储库，并且用户可以对项目下的镜像或Helm图表具有不同的权限。
>
> ***\*☆\** 基于策略的复制：**可以使用过滤器基于策略在多个注册表实例之间复制（同步）镜像和图表。
>
> ***\*☆\** 镜像删除和垃圾收集：**系统管理员可以运行垃圾收集作业，以便可以删除镜像，并可以定期释放其空间。
>
> ***\*☆\** 漏洞扫描：**Harbor会定期扫描映像中的漏洞，并进行策略检查以防止部署易受攻击的映像。
>
> ***\*☆\** 公证人：**支持对容器镜像进行签名，以确保真实性和出处。
>
> ***\*☆\** 审核：**通过日志跟踪对存储库的所有操作。
>
> ***\*☆\** 图形门户：**用户可以轻松浏览，搜索存储库和管理项目。
>
> ***\*☆\** 外部集成：**提供RESTful API有助于管理操作，并且易于与外部系统集成。

 

------

# 硬件要求

![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324085950541-1585586140.png)

# 软件要求

| 软件           | 版本                   | 描述                                                         |
| -------------- | ---------------------- | ------------------------------------------------------------ |
| Docker-engine  | v17.06.0-ce 或更高版本 | 有关安装说明，请参阅 [Docker Engine文档。](https://docs.docker.com/engine/installation/) |
| Docker-compose | v1.18.0 或更高版本     | 有关安装说明，请参阅 [Docker Compose文档。](https://docs.docker.com/compose/install/) |
| Openssl        | 最好是最新的           | 用于生成Harbor的证书和密钥                                   |

#  

#  

#  

#  

# 网络端口

![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324090025305-204319206.png)

 

 

------

# 下载地址

　　 https://github.com/goharbor/harbor/releases

![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324090246759-297962666.png)

Harbor官方分别提供了在线版（不含组件镜像，相对较小）和离线版（包含组件镜像，相对较大）。

由于github下载非常非常的慢，在此提供最新离线版包 [harbor-offline-installer-v1.10.1.tgz ](https://pan.baidu.com/s/1IKhBILaocDJkUveG-rXgVQ)（提取码: 7bts）。

 

 

------

# 创建 https 证书

#### **1）最简单方式**

```
mkdir -p /data/cert && chmod -R 777 /data/cert && cd /data/cert
openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout harbor.key -out harbor.crt -subj "/CN=hub.jhmy.com"
```

#### 2）去私钥方式

![img](https://images.cnblogs.com/OutliningIndicators/ExpandedBlockStart.gif)

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
# 创建证书目录，并赋予权限
mkdir -p /data/cert && chmod -R 777 /data/cert && cd /data/cert
# 生成私钥，需要设置密码
openssl genrsa -des3 -out harbor.key 2048

# 生成CA证书，需要输入密码
openssl req -sha512 -new \
    -subj "/C=CN/ST=JS/L=WX/O=zwx/OU=jhmy/CN=hub.jhmy.com" \
    -key harbor.key \
    -out harbor.csr

# 备份证书
cp harbor.key harbor.key.org

# 退掉私钥密码，以便docker访问（也可以参考官方进行双向认证）
openssl rsa -in harbor.key.org -out harbor.key

# 使用证书进行签名
openssl x509 -req -days 365 -in harbor.csr -signkey harbor.key -out harbor.crt
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

#### 3）官方认证方式

https://goharbor.io/docs/1.10/install-config/configure-https/ 

#### 4）主从复制方式

### [harbor私有镜像仓库的搭建与使用与主从复制](https://www.cnblogs.com/cash-su/p/10103885.html)

 

------

# 部署安装

- ### 解压软件包

![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324094006439-1417716576.png)

- ### 编辑harbor.yml，修改hostname、https证书路径、admin密码

 ![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324093601713-773168906.png)

- ###  运行install.sh即可（可带参数--with-notary启用镜像签名，--with-clair启用漏洞扫描）

 **流程：**检查环境 -> 导入镜像 -> 准备环境 -> 准备配置（含移除旧版本）-> 开始启动

![img](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif) install.logs

 ![img](https://img2020.cnblogs.com/blog/1059616/202003/1059616-20200324081158540-2035184059.png)

- ### 部署完成，以https方式访问宿主机地址即可

　　![img](https://img2020.cnblogs.com/blog/1059616/202004/1059616-20200410134929500-1563628957.png)

 

------

# 应用配置

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
# 配置镜像仓库地址（推荐配置域名）
vim/etc/docker/daemon.json
{ 
"insecure-registries": ["serverip"]
}

# 下载测试镜像
docker pull hello-world

# 给镜像重新打标签
docker tag hello-world serverip/library/hello-world:latest

# 登录进行上传
docker login serverip
docker push serverip/library/hello-world:latest
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

 

------

# 在线部署

　　如果你既不想下载离线包，国外网又不好，那就使用我的阿里云镜像源吧。

　　首先下载镜像，脚本如下：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
#!/bin/sh
# creator: leozhanggg
# up-date: 2020/04/08
# description: pullImage.sh

images="chartmuseum-photon:v0.9.0-v1.10.1 \
 harbor-migrator:v1.10.1 \
 redis-photon:v1.10.1 \
 clair-adapter-photon:v1.0.1-v1.10.1 \
 clair-photon:v2.1.1-v1.10.1 \
 notary-server-photon:v0.6.1-v1.10.1 \
 notary-signer-photon:v0.6.1-v1.10.1 \
 harbor-registryctl:v1.10.1 \
 registry-photon:v2.7.1-patch-2819-2553-v1.10.1 \
 nginx-photon:v1.10.1 \
 harbor-log:v1.10.1 \
 harbor-jobservice:v1.10.1 \
 harbor-core:v1.10.1 \
 harbor-portal:v1.10.1 \
 harbor-db:v1.10.1 \
 prepare:v1.10.1"

for image in ${images}; do
  imagefull=registry.cn-shanghai.aliyuncs.com/leozhanggg/goharbor/${image}
  docker pull ${imagefull}
  docker tag ${imagefull} goharbor/${image}
  docker rmi ${imagefull}
done
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

　　然后参考上面创建https证书，进行部署：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
# 配置镜像加速地址
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://jc3y13r3.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload && systemctl restart docker

# 执行脚本拉取镜像
sh pullImage.sh 

# 下载在线安装包（8.29k）
wget https://github.com/goharbor/harbor/releases/download/v1.10.1/harbor-online-installer-v1.10.1.tgz

# 解压并修改配置文件
tar -zxvf harbor-online-installer-v1.10.1.tgz && cd harbor
vim harbor.yml

# 执行部署
./install    
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

 

------

# 其他说明

- 新版本的harbor使用的是pg数据库，如果你是很老的版本，可能使用的还是mysql，所以需要手动暂停老服务。

　　 并且需要备份并删除/data/database文件夹，否则新版本pg将无法解析老的mysql数据，而导致安装失败，对于两个数据库数据转换是个麻烦事。

 

- 界面变化

![img](https://img2020.cnblogs.com/blog/1059616/202004/1059616-20200408140129691-1888661038.png)

![img](https://img2020.cnblogs.com/blog/1059616/202004/1059616-20200408140200721-681763214.png)

 

 

 

> 作者：[Leozhang](https://www.cnblogs.com/leozhanggg/)gg
>
> 出处：https://www.cnblogs.com/leozhanggg/p/12554399.html
>
> 本文版权归作者和博客园共有，欢迎转载，但未经作者同意必须保留此段声明，且在文章页面明显位置给出原文连接，否则保留追究法律责任的权利。