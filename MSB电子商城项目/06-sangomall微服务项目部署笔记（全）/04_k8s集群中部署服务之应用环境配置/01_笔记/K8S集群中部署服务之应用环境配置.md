# 微服务项目sangomall应用环境配置说明



# 一、应用环境配置文件创建

可以创建多个application.properties或application.yml文件,通过关键配置进行激活使用，例如测试环境和生产环境等。



## 1.1 创建开发环境（dev）

名称：application-dev.properties

激活的方法：

~~~powershell
在application.properties中添加激活使用
spring.profiles.active=dev
~~~



也可以在Dockerfile文件中启动命令时添加



~~~powershell
FROM openjdk:8
EXPOSE 8080

VOLUME /tmp

ADD target/*/jar /app.jar

RUN bash -c 'touch /app.jar'

ENTRYPOINT ["java","-jar","/app.jar","--spring.profiles.active=dev"]
~~~





## 1.2 创建生产环境（prod）

 名称：application-prod.properties

激活的方法：

~~~powershell
在application.properties中添加激活使用
spring.profiles.active=prod
~~~



也可以在Dockerfile文件中启动命令时添加



~~~powershell
FROM openjdk:8
EXPOSE 8080

VOLUME /tmp

ADD target/*/jar /app.jar

RUN bash -c 'touch /app.jar'

ENTRYPOINT ["java","-jar","/app.jar","--spring.profiles.active=prod"]
~~~



# 二、应用环境配置文件修改



## 2.1 Nacos



![image-20221121130636605](K8S集群中部署服务之应用环境配置.assets/image-20221121130636605.png)



~~~powershell
集群外域名访问：
nacos-server.msb.com 192.168.10.70
~~~



~~~powershell
集群内域名访问：
nacos-server.sangomall.svc.cluster.local.  8848
~~~



## 2.2 Redis



![image-20221121131115883](K8S集群中部署服务之应用环境配置.assets/image-20221121131115883.png)





~~~powershell
集群内域名访问：
redis.sangomall.svc.cluster.local.  6379
~~~



## 2.3 Sentinel



![image-20221121131532331](K8S集群中部署服务之应用环境配置.assets/image-20221121131532331.png)



~~~powershell
集群外域名访问：
sentinel-server.msb.com  192.168.10.70
~~~



~~~powershell
集群内域名访问：
sentinel-server.sangomall.svc.cluster.local. 8858
~~~



## 2.4 Zipkin



![image-20221121132721272](K8S集群中部署服务之应用环境配置.assets/image-20221121132721272.png)



~~~powershell
集群外域名访问：
zipkin-server.msb.com 192.168.10.70
~~~





~~~powershell
集群内域名访问：
zipkin-server.sangomall.svc.cluster.local. 9411
~~~





## 2.5 RocketMQ



![image-20221122151519541](K8S集群中部署服务之应用环境配置.assets/image-20221122151519541.png)



~~~powershell
集群内域名访问：

rocketmq-namesrv.sangomall.svc.cluster.local.:9876
~~~



## 2.6 MySQL



~~~powershell
集群内域名访问：
mysql-master.sangomall.svc.cluster.local.:3306
~~~



## 2.7 elasticsearch



~~~powershell
elasticsearch.sangomall.svc.cluster.local.:9200
~~~





# 三、各微服务应用环境配置文件修改

## 3.1 mall-auth_server

![image-20221121155704105](K8S集群中部署服务之应用环境配置.assets/image-20221121155704105.png)



![image-20221121155904227](K8S集群中部署服务之应用环境配置.assets/image-20221121155904227.png)







![image-20221121171059729](K8S集群中部署服务之应用环境配置.assets/image-20221121171059729.png)







~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858

redis.sangomall.svc.cluster.local.
~~~



![image-20221121164134751](K8S集群中部署服务之应用环境配置.assets/image-20221121164134751.png)





![image-20221208115941323](K8S集群中部署服务之应用环境配置.assets/image-20221208115941323.png)





~~~powershell
  thymeleaf:
    cache: false 
    prefix: classpath:/templates
    suffix: .html
~~~





## 3.2 mall-cart

![image-20221121164623430](K8S集群中部署服务之应用环境配置.assets/image-20221121164623430.png)





![image-20221121164650331](K8S集群中部署服务之应用环境配置.assets/image-20221121164650331.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858

redis.sangomall.svc.cluster.local.
~~~



![image-20221121171740428](K8S集群中部署服务之应用环境配置.assets/image-20221121171740428.png)





![image-20221121171825602](K8S集群中部署服务之应用环境配置.assets/image-20221121171825602.png)







## 3.3 mall-commons

> 不需要配置







## 3.4 mall-coupon



![image-20221121172103201](K8S集群中部署服务之应用环境配置.assets/image-20221121172103201.png)



![image-20221121172132317](K8S集群中部署服务之应用环境配置.assets/image-20221121172132317.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

mysql-master.sangomall.svc.cluster.local.:3306/mall_sms
~~~



![image-20221121172516848](K8S集群中部署服务之应用环境配置.assets/image-20221121172516848.png)



![image-20221121172558140](K8S集群中部署服务之应用环境配置.assets/image-20221121172558140.png)



## 3.5 mall-gateway



![image-20221121172723755](K8S集群中部署服务之应用环境配置.assets/image-20221121172723755.png)







~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858

redis.sangomall.svc.cluster.local.
~~~



![image-20221121174021304](K8S集群中部署服务之应用环境配置.assets/image-20221121174021304.png)



![image-20221121174136604](K8S集群中部署服务之应用环境配置.assets/image-20221121174136604.png)





![image-20221121174223044](K8S集群中部署服务之应用环境配置.assets/image-20221121174223044.png)





## 3.6 mall-member



![image-20221121174423290](K8S集群中部署服务之应用环境配置.assets/image-20221121174423290.png)





![image-20221121174446908](K8S集群中部署服务之应用环境配置.assets/image-20221121174446908.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

mysql-master.sangomall.svc.cluster.local.:3306/mall_ums
~~~



![image-20221121174705662](K8S集群中部署服务之应用环境配置.assets/image-20221121174705662.png)



![image-20221121174748249](K8S集群中部署服务之应用环境配置.assets/image-20221121174748249.png)



## 3.7 mall-order



![image-20221121174952533](K8S集群中部署服务之应用环境配置.assets/image-20221121174952533.png)





![image-20221121175025713](K8S集群中部署服务之应用环境配置.assets/image-20221121175025713.png)







~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

mysql-master.sangomall.svc.cluster.local.:3306/mall_oms

rocketmq-namesrv.sangomall.svc.cluster.local.:9876
~~~



![image-20221122151118349](K8S集群中部署服务之应用环境配置.assets/image-20221122151118349.png)





![image-20221122151235486](K8S集群中部署服务之应用环境配置.assets/image-20221122151235486.png)







![image-20221122180059812](K8S集群中部署服务之应用环境配置.assets/image-20221122180059812.png)



![image-20221122181128022](K8S集群中部署服务之应用环境配置.assets/image-20221122181128022.png)





![image-20221130115513372](K8S集群中部署服务之应用环境配置.assets/image-20221130115513372.png)







![image-20221130115629787](K8S集群中部署服务之应用环境配置.assets/image-20221130115629787.png)





## 3.8 mall-product



![image-20221121183911790](K8S集群中部署服务之应用环境配置.assets/image-20221121183911790.png)







![image-20221121183955253](K8S集群中部署服务之应用环境配置.assets/image-20221121183955253.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

mysql-master.sangomall.svc.cluster.local.:3306/mall_pms

rocketmq-namesrv.sangomall.svc.cluser.local.:9876
~~~



~~~powershell

endpoint oss-cn-beijing.aliyuncs.com

bucket名称 msb-laoshi-public
地域 beijing
~~~



![image-20221122182150675](K8S集群中部署服务之应用环境配置.assets/image-20221122182150675.png)





![image-20221122182252131](K8S集群中部署服务之应用环境配置.assets/image-20221122182252131.png)







![image-20221130115427668](K8S集群中部署服务之应用环境配置.assets/image-20221130115427668.png)







## 3.9 mall-search



![image-20221122182503763](K8S集群中部署服务之应用环境配置.assets/image-20221122182503763.png)







~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

elasticsearch.sangomall.svc.cluster.local.:9200
~~~



![image-20221122183706914](K8S集群中部署服务之应用环境配置.assets/image-20221122183706914.png)



![image-20221122183812271](K8S集群中部署服务之应用环境配置.assets/image-20221122183812271.png)







![image-20221130120448926](K8S集群中部署服务之应用环境配置.assets/image-20221130120448926.png)







## 3.10 mall-seckill



![image-20221122184050082](K8S集群中部署服务之应用环境配置.assets/image-20221122184050082.png)







~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

rocketmq-namesrv.sangomall.svc.cluser.local.:9876
~~~





![image-20221130120907623](K8S集群中部署服务之应用环境配置.assets/image-20221130120907623.png)



![image-20221122184415296](K8S集群中部署服务之应用环境配置.assets/image-20221122184415296.png)



![image-20221122184504036](K8S集群中部署服务之应用环境配置.assets/image-20221122184504036.png)





![image-20221209180136717](K8S集群中部署服务之应用环境配置.assets/image-20221209180136717.png)



## 3.11 mall-third-party



![image-20221122184620639](K8S集群中部署服务之应用环境配置.assets/image-20221122184620639.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

rocketmq-namesrv.sangomall.svc.cluser.local.:9876
~~~



~~~powershell

endpoint oss-cn-beijing.aliyuncs.com

bucket名称 msb-laoshi-public
地域 beijing
~~~



![image-20221122192240885](K8S集群中部署服务之应用环境配置.assets/image-20221122192240885.png)



![image-20221122192330791](K8S集群中部署服务之应用环境配置.assets/image-20221122192330791.png)





## 3.12 mall-ware



![image-20221122192434661](K8S集群中部署服务之应用环境配置.assets/image-20221122192434661.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858

mysql-master.sangomall.svc.cluster.local.:3306/mall_wms
~~~



![image-20221122192931753](K8S集群中部署服务之应用环境配置.assets/image-20221122192931753.png)



![image-20221122193017765](K8S集群中部署服务之应用环境配置.assets/image-20221122193017765.png)





## 3.13 renren-fast-master



![image-20221122193435890](K8S集群中部署服务之应用环境配置.assets/image-20221122193435890.png)





~~~powershell
集群内访问域名：
nacos-server.sangomall.svc.cluster.local.:8848
sentinel-server.sangomall.svc.cluster.local.:8858
redis.sangomall.svc.cluster.local.

mysql-master.sangomall.svc.cluster.local.:3306/renren_fast

rocketmq-namesrv.sangomall.svc.cluser.local.:9876
~~~



![image-20221122193753228](K8S集群中部署服务之应用环境配置.assets/image-20221122193753228.png)





![image-20221122194141379](K8S集群中部署服务之应用环境配置.assets/image-20221122194141379.png)



![image-20221122194422058](K8S集群中部署服务之应用环境配置.assets/image-20221122194422058.png)



![image-20221122194548106](K8S集群中部署服务之应用环境配置.assets/image-20221122194548106.png)





![image-20221122194642734](K8S集群中部署服务之应用环境配置.assets/image-20221122194642734.png)





## 3.14 renre-generator-master



![image-20221122204349602](K8S集群中部署服务之应用环境配置.assets/image-20221122204349602.png)









~~~powershell
mysql-master.sangomall.svc.cluster.local.:3306/mall_sms
~~~



![image-20221122204441230](K8S集群中部署服务之应用环境配置.assets/image-20221122204441230.png)



# 四、添加nexus-aliyun仓库



![image-20221208122805609](K8S集群中部署服务之应用环境配置.assets/image-20221208122805609.png)



~~~powershell
<settings>
    <mirrors>
        <mirror>
            <id>nexus-aliyun</id>
            <mirrorOf>central</mirrorOf>
            <name>Nexus aliyun</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public</url>
        </mirror>
    </mirrors>

</settings>
~~~



