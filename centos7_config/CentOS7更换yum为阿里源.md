#### [CentOS7更换yum为阿里源](https://www.cnblogs.com/jincieryi1120/p/12129890.html)

### 1 备份本地源

- `mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo_bak`

### 2 获取阿里源配置文件

- `wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo`

### 3 更新epel仓库

- `wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo`

### 4 更新cache

- `yum makecache`

