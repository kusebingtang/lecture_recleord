# Harbor仓库清理

Harbor私有仓库运行一段时间后，仓库中存有大量镜像，会占用太多的存储空间。直接通过Harbor界面删除相关镜像，并不会自动删除存储中的文件和镜像。需要停止Harbor服务，执行垃圾回收命令，进行存储空间清理和回收。

1.停止Harbor相关服务
docker-compose stop
1
2.打印出来要清理的镜像，不删除，带有–dry-run选项，可以查看到将要删除的镜像文件
docker run -it --name gc --rm --volumes-from registry vmware/registry-photon:v2.6.2-v1.5.0 garbage-collect --dry-run /etc/registry/config.yml
1
3.打印出来并且删除要清理的镜像
docker run -it --name gc --rm --volumes-from registry vmware/registry-photon:v2.6.2-v1.5.0 garbage-collect /etc/registry/config.yml
1
4.docker文件存放地址
cd /data/registry/docker/registry/v2/
1
5.重新启动
docker-compose start
1
文章知识点与官方知识档案匹配，可进一步学习相关知识
云原生入门技能树容器(docker)安装docker1022 人正在系统学习中
————————————————
版权声明：本文为CSDN博主「swalikh」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/swalikh/article/details/122848084