# ES启动异常

```ABAP
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```



现象
ES启动时出现异常

```bash
bin/elasticsearch
 
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

原因分析
系统[虚拟内存](https://so.csdn.net/so/search?q=虚拟内存&spm=1001.2101.3001.7020)默认最大映射数为65530，无法满足ES系统要求，需要调整为262144以上。

处理办法
设置vm.max_map_count参数

```bash
#修改文件
sudo vim /etc/sysctl.conf
 
#添加参数
...
vm.max_map_count = 262144
```

重新加载/etc/sysctl.conf配置

```bash
sysctl -p
```

