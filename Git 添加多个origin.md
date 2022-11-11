# Git 添加多个origin


一、查看当前remote个数

```sh
git remote -v
```

二、添加新的remote

```sh
git remote add myOrigin xxxxxxxxxxx(地址)
```


三、项目添加到缓存区

四、上传代码

```sh
git push -u myOrigin master
```


五、以后的推拉代码方式

```sh
git pull myOrigin       拉代码
git push myOrigin     推代码
```

