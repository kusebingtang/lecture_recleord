# ssh-keygen命令详解

**简介** 这篇文章主要介绍了ssh-keygen命令详解以及相关的经验技巧，文章约2550字，浏览量432，点赞数3，值得参考！

> 为ssh生成、管理和转换认证密钥,ssh-keygen命令 用于为“ssh”生成、管理和转换认证密钥，它支持RSA和DSA两种认证密钥。

> SSH 密钥默认保留在 `~/.ssh` 目录中。如果没有 `~/.ssh` 目录，`ssh-keygen`命令会使用正确的权限创建一个。

### 命令语法

```
ssh-keygen [选项]
```

### 命令选项

- -b：指定密钥长度；
- -e：读取openssh的私钥或者公钥文件；
- -C：添加注释；
- -f：指定用来保存密钥的文件名；
- -i：读取未加密的ssh-v2兼容的私钥/公钥文件，然后在标准输出设备上显示openssh兼容的私钥/公钥；
- -l：显示公钥文件的指纹数据；
- -N：提供一个新密语；
- -P：提供（旧）密语；
- -q：静默模式；
- -t：指定要创建的密钥类型。

### 基本示例

> 以下 ssh-keygen 命令默认在 ~/.ssh 目录中生成 4096 位 SSH RSA 公钥和私钥文件。如果当前位置存在 SSH 密钥对，这些文件将被覆盖。

```
> ssh-keygen -m PEM -t rsa -b 4096
```

> 使用`ssh-kengen`会在`~/.ssh/`目录下生成两个文件，不指定文件名和密钥类型的时候，默认生成的两个文件是

- `id_rsa` 第一个是私钥文件
- `id_rsa.pub` 第二个是公钥文件

### 指定秘钥文件路径

```
> ssh-keygen -t rsa -C 'rumenz@qq.com' -f ~/.ssh/github_id_rsa
```

> 或者，在指定存放文件时输入一个新的文件名

```
> Enter file in which to save the key(/Users/rumenz/.ssh/id_rsa):id_rsa_gitlab
```

> 多个`SSH key`的管理的情况就需要指定秘钥文件名。