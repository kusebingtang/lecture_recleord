# 微服务项目部署之流水线编写



# 一、部署微服务项目环境说明

## 1.1 代码托管到gitee



![image-20221127154849203](k8s集群中部署项目之流水线.assets/image-20221127154849203.png)



![image-20221127154936408](k8s集群中部署项目之流水线.assets/image-20221127154936408.png)



![image-20221127155046469](k8s集群中部署项目之流水线.assets/image-20221127155046469.png)



![image-20221127155230878](k8s集群中部署项目之流水线.assets/image-20221127155230878.png)





![image-20221127160027561](k8s集群中部署项目之流水线.assets/image-20221127160027561.png)





![image-20221127160344499](k8s集群中部署项目之流水线.assets/image-20221127160344499.png)



![image-20221127160245815](k8s集群中部署项目之流水线.assets/image-20221127160245815.png)



![image-20221127160733328](k8s集群中部署项目之流水线.assets/image-20221127160733328.png)



![image-20221127160827890](k8s集群中部署项目之流水线.assets/image-20221127160827890.png)



![image-20221127160931742](k8s集群中部署项目之流水线.assets/image-20221127160931742.png)





![image-20221127161017688](k8s集群中部署项目之流水线.assets/image-20221127161017688.png)



![image-20221127161139612](k8s集群中部署项目之流水线.assets/image-20221127161139612.png)



![image-20221127161228386](k8s集群中部署项目之流水线.assets/image-20221127161228386.png)



![image-20221127161307681](k8s集群中部署项目之流水线.assets/image-20221127161307681.png)







## 1.2 镜像托管到dockerhub



![image-20221127162752936](k8s集群中部署项目之流水线.assets/image-20221127162752936.png)





~~~powershell
用户名：nextgomsb
密码：abc***.com
~~~





## 1.3 流水线工具 KubeSphere



![image-20221127162951561](k8s集群中部署项目之流水线.assets/image-20221127162951561.png)





![image-20221127163041224](k8s集群中部署项目之流水线.assets/image-20221127163041224.png)



![image-20221127163101453](k8s集群中部署项目之流水线.assets/image-20221127163101453.png)



![image-20221127163136315](k8s集群中部署项目之流水线.assets/image-20221127163136315.png)



![image-20221127163202665](k8s集群中部署项目之流水线.assets/image-20221127163202665.png)



![image-20221127163226325](k8s集群中部署项目之流水线.assets/image-20221127163226325.png)





![image-20221127163303392](k8s集群中部署项目之流水线.assets/image-20221127163303392.png)







# 二、通过KubeSphere部署之拉取代码流水线编写



## 2.1 准备凭证

![image-20221127163921095](k8s集群中部署项目之流水线.assets/image-20221127163921095.png)



![image-20221127164411541](k8s集群中部署项目之流水线.assets/image-20221127164411541.png)



![image-20221127170856292](k8s集群中部署项目之流水线.assets/image-20221127170856292.png)





## 2.2 编辑流水线



![image-20221127205519288](k8s集群中部署项目之流水线.assets/image-20221127205519288.png)





![image-20221127205537019](k8s集群中部署项目之流水线.assets/image-20221127205537019.png)



![image-20221127205600230](k8s集群中部署项目之流水线.assets/image-20221127205600230.png)



![image-20221127205649139](k8s集群中部署项目之流水线.assets/image-20221127205649139.png)





![image-20221127205746358](k8s集群中部署项目之流水线.assets/image-20221127205746358.png)





![image-20221127210005540](k8s集群中部署项目之流水线.assets/image-20221127210005540.png)



![image-20221127210052246](k8s集群中部署项目之流水线.assets/image-20221127210052246.png)



![image-20221127210133104](k8s集群中部署项目之流水线.assets/image-20221127210133104.png)





~~~powershell
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
      }
    }

  }
}
~~~



## 2.3 测试流水线是否可以拉取项目代码



![image-20221127210244024](k8s集群中部署项目之流水线.assets/image-20221127210244024.png)



![image-20221127215333105](k8s集群中部署项目之流水线.assets/image-20221127215333105.png)







# 三、通过KubeSphere部署之参数化构建及环境变量设定



## 3.1 参数化构建



~~~powershell
在流水线中添加如下内容：

parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
~~~



~~~powershell
添加后的流水线内容：

pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
      }
    }

  }
}
~~~



**测试是否可行**



![image-20221127225224257](k8s集群中部署项目之流水线.assets/image-20221127225224257.png)



**验证在流水线中接收情况**



![image-20221127230538954](k8s集群中部署项目之流水线.assets/image-20221127230538954.png)





![image-20221127230639565](k8s集群中部署项目之流水线.assets/image-20221127230639565.png)



![image-20221127232133577](k8s集群中部署项目之流水线.assets/image-20221127232133577.png)



![image-20221127230839135](k8s集群中部署项目之流水线.assets/image-20221127230839135.png)





~~~powershell
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
}
~~~





![image-20221127231202447](k8s集群中部署项目之流水线.assets/image-20221127231202447.png)



![image-20221127231242736](k8s集群中部署项目之流水线.assets/image-20221127231242736.png)





![image-20221127232936900](k8s集群中部署项目之流水线.assets/image-20221127232936900.png)





**创建构建参数选项**





![image-20221127233628865](k8s集群中部署项目之流水线.assets/image-20221127233628865.png)



![image-20221127233723969](k8s集群中部署项目之流水线.assets/image-20221127233723969.png)



![image-20221127233804646](k8s集群中部署项目之流水线.assets/image-20221127233804646.png)





![image-20221127234024831](k8s集群中部署项目之流水线.assets/image-20221127234024831.png)







![image-20221127234329739](k8s集群中部署项目之流水线.assets/image-20221127234329739.png)

![image-20221127234428847](k8s集群中部署项目之流水线.assets/image-20221127234428847.png)





![image-20221127234607857](k8s集群中部署项目之流水线.assets/image-20221127234607857.png)





## 3.2 环境变量设定

### 3.2.1 凭证创建

#### 3.2.1.1 dockerhub-id

![image-20221127235341750](k8s集群中部署项目之流水线.assets/image-20221127235341750.png)





![image-20221127235503887](k8s集群中部署项目之流水线.assets/image-20221127235503887.png)



![image-20221127235522216](k8s集群中部署项目之流水线.assets/image-20221127235522216.png)





#### 3.2.1.2 kubeconfig



![image-20221127235557861](k8s集群中部署项目之流水线.assets/image-20221127235557861.png)



![image-20221127235700973](k8s集群中部署项目之流水线.assets/image-20221127235700973.png)





![image-20221127235748023](k8s集群中部署项目之流水线.assets/image-20221127235748023.png)



#### 3.2.1.3 sonar-qube



> sonar-qube部署及使用请参考上面的视频。



![image-20221127235819225](k8s集群中部署项目之流水线.assets/image-20221127235819225.png)











~~~powershell
sonar管理员令牌：4f1b3ad13420f738926140bcb110758f96aa5eac  新令牌：d19390c45296be3c44ca2cb902ffda01bd0d8d96
~~~





![image-20221128102646596](k8s集群中部署项目之流水线.assets/image-20221128102646596.png)



![image-20221128102710369](k8s集群中部署项目之流水线.assets/image-20221128102710369.png)







### 3.2.2 添加环境变量到jenkinsfile

~~~powershell
environment {
	DOCKER_CREDENTIAL_ID = 'dockerhub-id'
	GITEE_CREDENTIAL_ID = 'gitee-id'
	KUBECONFIG_CREDENTIAL_ID= 'sangomall-kubeconfig'
	REGISTRY = 'docker.io'
	DOCKERHUB_NAMESPACE = 'nextgomsb'
	GITEE_ACCOUNT = 'nextgomsb'
	SONAR_CREDENTIAL_ID = 'sonar-qube'
}
~~~



~~~powershell
添加后的内容：
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
  environment {
  	DOCKER_CREDENTIAL_ID = 'dockerhub-id'
  	GITEE_CREDENTIAL_ID = 'gitee-id'
  	KUBECONFIG_CREDENTIAL_ID= 'sangomall-kubeconfig'
  	REGISTRY = 'docker.io'
  	DOCKERHUB_NAMESPACE = 'nextgomsb'
  	GITEE_ACCOUNT = 'nextgomsb'
  	SONAR_CREDENTIAL_ID = 'sonar-qube'
}
  
}
~~~





# 四、通过KubeSphere部署之Sonar集成至流水线编写

> sonarqube集成可参考前操作步骤实施。



![image-20221128111657036](k8s集群中部署项目之流水线.assets/image-20221128111657036.png)





![image-20221128111744254](k8s集群中部署项目之流水线.assets/image-20221128111744254.png)



![image-20221128111823041](k8s集群中部署项目之流水线.assets/image-20221128111823041.png)



![image-20221128111841138](k8s集群中部署项目之流水线.assets/image-20221128111841138.png)



![image-20221128111933907](k8s集群中部署项目之流水线.assets/image-20221128111933907.png)





![image-20221128112008604](k8s集群中部署项目之流水线.assets/image-20221128112008604.png)



![image-20221128112050609](k8s集群中部署项目之流水线.assets/image-20221128112050609.png)



![image-20221128112118254](k8s集群中部署项目之流水线.assets/image-20221128112118254.png)



![image-20221128112202401](k8s集群中部署项目之流水线.assets/image-20221128112202401.png)



![image-20221128112246196](k8s集群中部署项目之流水线.assets/image-20221128112246196.png)





![image-20221128112304951](k8s集群中部署项目之流水线.assets/image-20221128112304951.png)





![image-20221128112333959](k8s集群中部署项目之流水线.assets/image-20221128112333959.png)





![image-20221128112408202](k8s集群中部署项目之流水线.assets/image-20221128112408202.png)



![image-20221128112456079](k8s集群中部署项目之流水线.assets/image-20221128112456079.png)









~~~powershell
echo 当前目录 `pwd`
~~~



![image-20221128113146797](k8s集群中部署项目之流水线.assets/image-20221128113146797.png)





![image-20221128113222823](k8s集群中部署项目之流水线.assets/image-20221128113222823.png)



![image-20221128113243346](k8s集群中部署项目之流水线.assets/image-20221128113243346.png)



~~~powershell
mvn sonar:sonar -gs `pwd`/mvn_settings.xml -Dsonar.login=$SONAR_TOKEN
~~~



![image-20221128143202074](k8s集群中部署项目之流水线.assets/image-20221128143202074.png)





![image-20221128113338679](k8s集群中部署项目之流水线.assets/image-20221128113338679.png)





![image-20221128114243954](k8s集群中部署项目之流水线.assets/image-20221128114243954.png)



![image-20221128114317392](k8s集群中部署项目之流水线.assets/image-20221128114317392.png)





![image-20221128114342818](k8s集群中部署项目之流水线.assets/image-20221128114342818.png)





![image-20221128114424349](k8s集群中部署项目之流水线.assets/image-20221128114424349.png)



![image-20221128114505886](k8s集群中部署项目之流水线.assets/image-20221128114505886.png)



![image-20221128114537392](k8s集群中部署项目之流水线.assets/image-20221128114537392.png)



![image-20221128114605493](k8s集群中部署项目之流水线.assets/image-20221128114605493.png)





~~~powershell
添加sonarqube后流水线内容：
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

   
    stage('项目代码分析') {
      agent none
      steps {
        container('maven') {
          withCredentials([string(credentialsId : 'sonar-qube' ,variable : 'SONAR_TOKEN' ,)]) {
            withSonarQubeEnv('sonar') {
              sh 'echo 当前目录 `pwd`'
              sh 'mvn clean install -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
              sh 'mvn sonar:sonar -gs `pwd`/mvn_settings.xml  -Dsonar.login=$SONAR_TOKEN'
            }

          }

          timeout(unit: 'HOURS', activity: true, time: 1) {
            waitForQualityGate 'true'
          }

        }

      }
    }

  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITEE_CREDENTIAL_ID = 'gitee-id'
    KUBECONFIG_CREDENTIAL_ID = 'sangomall-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE = 'nextgomsb'
    GITEE_ACCOUNT = 'nextgomsb'
    SONAR_CREDENTIAL_ID = 'sonar-qube'
    
  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
}
~~~





![image-20221128144347484](k8s集群中部署项目之流水线.assets/image-20221128144347484.png)





![image-20221128141902772](k8s集群中部署项目之流水线.assets/image-20221128141902772.png)







# 五、通过KubeSphere部署之单元测试集成至流水线编写



![image-20221128103227797](k8s集群中部署项目之流水线.assets/image-20221128103227797.png)



![image-20221128103323127](k8s集群中部署项目之流水线.assets/image-20221128103323127.png)



![image-20221128103353780](k8s集群中部署项目之流水线.assets/image-20221128103353780.png)



![image-20221128103423509](k8s集群中部署项目之流水线.assets/image-20221128103423509.png)



![image-20221128103449658](k8s集群中部署项目之流水线.assets/image-20221128103449658.png)





![image-20221128103511027](k8s集群中部署项目之流水线.assets/image-20221128103511027.png)





~~~powershell
mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml
~~~





![image-20221128143316979](k8s集群中部署项目之流水线.assets/image-20221128143316979.png)





![image-20221128103632834](k8s集群中部署项目之流水线.assets/image-20221128103632834.png)





~~~powershell
添加单元测试后jenkinsfile内容：
添加sonarqube后流水线内容：
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

   

    stage('项目代码分析') {
      agent none
      steps {
        container('maven') {
          withCredentials([string(credentialsId : 'sonar-qube' ,variable : 'SONAR_TOKEN' ,)]) {
            withSonarQubeEnv('sonar') {
              sh 'echo 当前目录 `pwd`'
              sh 'mvn clean install -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
              sh 'mvn sonar:sonar -gs `pwd`/mvn_settings.xml  -Dsonar.login=$SONAR_TOKEN'
            }

          }

          timeout(unit: 'HOURS', activity: true, time: 1) {
            waitForQualityGate 'true'
          }

        }

      }
    }
    
     stage('单元测试') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
        }

      }
    }

  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITEE_CREDENTIAL_ID = 'gitee-id'
    KUBECONFIG_CREDENTIAL_ID = 'sangomall-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE = 'nextgomsb'
    GITEE_ACCOUNT = 'nextgomsb'
    SONAR_CREDENTIAL_ID = 'sonar-qube'
    
  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
}
~~~









# 六、通过KubeSphere部署之构建项目镜像及推送镜像至dockerhub流水线编写



![image-20221128145242766](k8s集群中部署项目之流水线.assets/image-20221128145242766.png)



![image-20221128145325385](k8s集群中部署项目之流水线.assets/image-20221128145325385.png)





![image-20221128145338427](k8s集群中部署项目之流水线.assets/image-20221128145338427.png)





![image-20221128145401549](k8s集群中部署项目之流水线.assets/image-20221128145401549.png)



![image-20221128145424178](k8s集群中部署项目之流水线.assets/image-20221128145424178.png)





![image-20221128145443792](k8s集群中部署项目之流水线.assets/image-20221128145443792.png)



![image-20221128145506967](k8s集群中部署项目之流水线.assets/image-20221128145506967.png)





![image-20221128145557419](k8s集群中部署项目之流水线.assets/image-20221128145557419.png)





~~~powershell
mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml
~~~



![image-20221128145706021](k8s集群中部署项目之流水线.assets/image-20221128145706021.png)



![image-20221128145728241](k8s集群中部署项目之流水线.assets/image-20221128145728241.png)



![image-20221128160439649](k8s集群中部署项目之流水线.assets/image-20221128160439649.png)



~~~powershell
cd $PROJECT_NAME && docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER .
~~~



![image-20221128152150147](k8s集群中部署项目之流水线.assets/image-20221128152150147.png)



![image-20221128152219521](k8s集群中部署项目之流水线.assets/image-20221128152219521.png)





![image-20221128152323287](k8s集群中部署项目之流水线.assets/image-20221128152323287.png)





![image-20221128152417516](k8s集群中部署项目之流水线.assets/image-20221128152417516.png)



![image-20221128152451286](k8s集群中部署项目之流水线.assets/image-20221128152451286.png)



~~~powershell
echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin
~~~



![image-20221128152551249](k8s集群中部署项目之流水线.assets/image-20221128152551249.png)





![image-20221128152622854](k8s集群中部署项目之流水线.assets/image-20221128152622854.png)



![image-20221128152710561](k8s集群中部署项目之流水线.assets/image-20221128152710561.png)



![image-20221128152732871](k8s集群中部署项目之流水线.assets/image-20221128152732871.png)





~~~powershell
docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER
~~~



![image-20221128152852509](k8s集群中部署项目之流水线.assets/image-20221128152852509.png)





~~~powershell
添加构建与推送容器镜像后内容如下：

pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

    stage('单元测试') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
        }

      }
    }

    stage('项目代码分析') {
      agent none
      steps {
        container('maven') {
          withCredentials([string(credentialsId : 'sonar-qube' ,variable : 'SONAR_TOKEN' ,)]) {
            withSonarQubeEnv('sonar') {
              sh 'echo 当前目录 `pwd`'
              sh 'mvn clean install -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
              sh 'mvn sonar:sonar -gs `pwd`/mvn_settings.xml  -Dsonar.login=$SONAR_TOKEN'
            }

          }

          timeout(unit: 'HOURS', activity: true, time: 1) {
            waitForQualityGate 'true'
          }

        }

      }
    }

    stage('构建并推送容器镜像') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
          sh 'cd $PROJECT_NAME && docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER .'
          withCredentials([usernamePassword(credentialsId : 'dockerhub-id' ,passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,)]) {
            sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
            sh 'echo $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
          }

        }

      }
    }


  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITEE_CREDENTIAL_ID = 'gitee-id'
    KUBECONFIG_CREDENTIAL_ID = 'sangomall-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE= 'nextgomsb'
    GITEE_ACCOUNT = 'nextgomsb'
    SONAR_CREDENTIAL_ID = 'sonar-qube'
  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
}
~~~





![image-20221128160611270](k8s集群中部署项目之流水线.assets/image-20221128160611270.png)





![image-20221129123418124](k8s集群中部署项目之流水线.assets/image-20221129123418124.png)







**推送最终容器镜像到DockerHub仓库**



~~~powershell
docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest
~~~



![image-20221129135523996](k8s集群中部署项目之流水线.assets/image-20221129135523996.png)



![image-20221129135554135](k8s集群中部署项目之流水线.assets/image-20221129135554135.png)



![image-20221129135633062](k8s集群中部署项目之流水线.assets/image-20221129135633062.png)







~~~powershell
docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest
~~~



![image-20221129135719707](k8s集群中部署项目之流水线.assets/image-20221129135719707.png)





![image-20221129135822757](k8s集群中部署项目之流水线.assets/image-20221129135822757.png)



![image-20221129135906239](k8s集群中部署项目之流水线.assets/image-20221129135906239.png)





![image-20221129135942411](k8s集群中部署项目之流水线.assets/image-20221129135942411.png)



~~~powershell
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

    stage('单元测试') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
        }

      }
    }

    stage('项目代码分析') {
      agent none
      steps {
        container('maven') {
          withCredentials([string(credentialsId : 'sonar-qube' ,variable : 'SONAR_TOKEN' ,)]) {
            withSonarQubeEnv('sonar') {
              sh 'echo 当前目录 `pwd`'
              sh 'mvn clean install -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
              sh 'mvn sonar:sonar -gs `pwd`/mvn_settings.xml  -Dsonar.login=$SONAR_TOKEN'
            }

          }

          timeout(unit: 'HOURS', activity: true, time: 1) {
            waitForQualityGate 'true'
          }

        }

      }
    }

    stage('构建并推送容器镜像') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
          sh 'cd $PROJECT_NAME && docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER .'
          withCredentials([usernamePassword(credentialsId : 'dockerhub-id' ,passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,)]) {
            sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
            sh 'echo $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest'
            sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest'
          }

        }

      }
    }

  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITEE_CREDENTIAL_ID = 'gitee-id'
    KUBECONFIG_CREDENTIAL_ID = 'sangomall-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE = 'nextgomsb'
    GITEE_ACCOUNT = 'nextgomsb'
    SONAR_CREDENTIAL_ID = 'sonar-qube'

  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
}
~~~



![image-20221129141354479](k8s集群中部署项目之流水线.assets/image-20221129141354479.png)



![image-20221129141436402](k8s集群中部署项目之流水线.assets/image-20221129141436402.png)







# 七、通过KubeSphere部署之为项目发布准备对应版本的容器镜像



![image-20221129175701257](k8s集群中部署项目之流水线.assets/image-20221129175701257.png)



![image-20221129175740422](k8s集群中部署项目之流水线.assets/image-20221129175740422.png)



![image-20221129175814854](k8s集群中部署项目之流水线.assets/image-20221129175814854.png)



~~~powershell
return params.PROJECT_VERSION =~ /v.*/
~~~





![image-20221129180028245](k8s集群中部署项目之流水线.assets/image-20221129180028245.png)



![image-20221129180049392](k8s集群中部署项目之流水线.assets/image-20221129180049392.png)



![image-20221129180127897](k8s集群中部署项目之流水线.assets/image-20221129180127897.png)



![image-20221129180146365](k8s集群中部署项目之流水线.assets/image-20221129180146365.png)





![image-20221129180210829](k8s集群中部署项目之流水线.assets/image-20221129180210829.png)



![image-20221129180248540](k8s集群中部署项目之流水线.assets/image-20221129180248540.png)



![image-20221129180316440](k8s集群中部署项目之流水线.assets/image-20221129180316440.png)



![image-20221129180418373](k8s集群中部署项目之流水线.assets/image-20221129180418373.png)





![image-20221129180516224](k8s集群中部署项目之流水线.assets/image-20221129180516224.png)



![image-20221129180540703](k8s集群中部署项目之流水线.assets/image-20221129180540703.png)





![image-20221129180958747](k8s集群中部署项目之流水线.assets/image-20221129180958747.png)



![image-20221129181020080](k8s集群中部署项目之流水线.assets/image-20221129181020080.png)



**添加GITEE设置**



![image-20221129181136758](k8s集群中部署项目之流水线.assets/image-20221129181136758.png)



![image-20221129181206599](k8s集群中部署项目之流水线.assets/image-20221129181206599.png)



~~~powershell
git config --global user.email "nextgo@126.com" 
~~~



![image-20221129181303959](k8s集群中部署项目之流水线.assets/image-20221129181303959.png)





![image-20221129181333114](k8s集群中部署项目之流水线.assets/image-20221129181333114.png)



![image-20221129181438397](k8s集群中部署项目之流水线.assets/image-20221129181438397.png)



~~~powershell
git config --global user.name "nextgo" 
~~~



![image-20221129181505865](k8s集群中部署项目之流水线.assets/image-20221129181505865.png)



![image-20221129181642993](k8s集群中部署项目之流水线.assets/image-20221129181642993.png)



![image-20221129181703192](k8s集群中部署项目之流水线.assets/image-20221129181703192.png)











~~~powershell
git tag -a $PROJECT_VERSION -m "$PROJECT_VERSION" 
~~~



![image-20221129181753291](k8s集群中部署项目之流水线.assets/image-20221129181753291.png)





![image-20221129181840532](k8s集群中部署项目之流水线.assets/image-20221129181840532.png)



![image-20221129181859921](k8s集群中部署项目之流水线.assets/image-20221129181859921.png)



~~~powershell
git push http://$GITEE_USERNAME:$GITEE_PASSWORD@gitee.com/$GITEE_ACCOUNT/sangomall.git --tags --ipv4
~~~



![image-20221129182108358](k8s集群中部署项目之流水线.assets/image-20221129182108358.png)





![image-20221129182133200](k8s集群中部署项目之流水线.assets/image-20221129182133200.png)



**添加dockerhub的配置**



![image-20221129182249026](k8s集群中部署项目之流水线.assets/image-20221129182249026.png)



![image-20221129182313301](k8s集群中部署项目之流水线.assets/image-20221129182313301.png)



~~~powershell
docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:$PROJECT_VERSION 
~~~



![image-20221129182614147](k8s集群中部署项目之流水线.assets/image-20221129182614147.png)



![image-20221129182644566](k8s集群中部署项目之流水线.assets/image-20221129182644566.png)







![image-20221129182707961](k8s集群中部署项目之流水线.assets/image-20221129182707961.png)



![image-20221129182731585](k8s集群中部署项目之流水线.assets/image-20221129182731585.png)



~~~powershell
docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:$PROJECT_VERSION
~~~



![image-20221129182847747](k8s集群中部署项目之流水线.assets/image-20221129182847747.png)



![image-20221129182916653](k8s集群中部署项目之流水线.assets/image-20221129182916653.png)







~~~powershell
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('获取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', branch: 'master', changelog: true, poll: false)
        sh '''echo $PROJECT_NAME
echo $PROJECT_VERSION'''
      }
    }

    stage('单元测试') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
        }

      }
    }

    stage('项目代码分析') {
      agent none
      steps {
        container('maven') {
          withCredentials([string(credentialsId : 'sonar-qube' ,variable : 'SONAR_TOKEN' ,)]) {
            withSonarQubeEnv('sonar') {
              sh 'echo 当前目录 `pwd`'
              sh 'mvn clean install -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
              sh 'mvn sonar:sonar -gs `pwd`/mvn_settings.xml  -Dsonar.login=$SONAR_TOKEN'
            }

          }

          timeout(unit: 'HOURS', activity: true, time: 1) {
            waitForQualityGate 'true'
          }

        }

      }
    }

    stage('构建并推送容器镜像') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
          sh 'cd $PROJECT_NAME && docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER .'
          withCredentials([usernamePassword(credentialsId : 'dockerhub-id' ,passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,)]) {
            sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
            sh 'echo $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest'
            sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest'
          }

        }

      }
    }

    stage('准备项目及镜像tag') {
      agent none
      when {
        expression {
          return params.PROJECT_VERSION =~ /v.*/
        }

      }
      steps {
        container('maven') {
          input(message: '''@project-admin  
是否提交带有tag的发布版本及容器镜像？''', submitter: 'project-admin')
          withCredentials([usernamePassword(credentialsId : 'gitee-id' ,passwordVariable : 'GITEE_PASSWORD' ,usernameVariable : 'GITEE_USERNAME' ,)]) {
            sh 'git config --global user.email "nextgo@126.com" '
            sh 'git config --global user.name "nextgo"'
            sh 'git tag -a $PROJECT_VERSION -m "$PROJECT_VERSION" '
            sh 'git push http://$GITEE_USERNAME:$GITEE_PASSWORD@gitee.com/$GITEE_ACCOUNT/sangomall.git --tags --ipv4'
          }

          sh 'docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:$PROJECT_VERSION '
          sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:$PROJECT_VERSION'
        }

      }
    }

  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITEE_CREDENTIAL_ID = 'gitee-id'
    KUBECONFIG_CREDENTIAL_ID = 'sangomall-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE = 'nextgomsb'
    GITEE_ACCOUNT = 'nextgomsb'
    SONAR_CREDENTIAL_ID = 'sonar-qube'
  }
  parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
}
~~~







# 八、通过KubeSphere部署之项目部署流水线编写



![image-20221129165006087](k8s集群中部署项目之流水线.assets/image-20221129165006087.png)



![image-20221129165106182](k8s集群中部署项目之流水线.assets/image-20221129165106182.png)



![image-20221129165251512](k8s集群中部署项目之流水线.assets/image-20221129165251512.png)





![image-20221129165321478](k8s集群中部署项目之流水线.assets/image-20221129165321478.png)



![image-20221129165414348](k8s集群中部署项目之流水线.assets/image-20221129165414348.png)





![image-20221129165439344](k8s集群中部署项目之流水线.assets/image-20221129165439344.png)



![image-20221129165534970](k8s集群中部署项目之流水线.assets/image-20221129165534970.png)



![image-20221129165617529](k8s集群中部署项目之流水线.assets/image-20221129165617529.png)



![image-20221129165721914](k8s集群中部署项目之流水线.assets/image-20221129165721914.png)



![image-20221129165751897](k8s集群中部署项目之流水线.assets/image-20221129165751897.png)







![image-20221129170249932](k8s集群中部署项目之流水线.assets/image-20221129170249932.png)



![image-20221129170321155](k8s集群中部署项目之流水线.assets/image-20221129170321155.png)





~~~powershell
mkdir ~/.kube
echo "$KUBECONFIG_CONTENT" > ~/.kube/config
envsubst < $PROJECT_NAME/deploy/deploy.yaml | kubectl apply -f -
~~~



![image-20221129170950963](k8s集群中部署项目之流水线.assets/image-20221129170950963.png)







# 九、创建项目jenkins文件



![image-20221129183911732](k8s集群中部署项目之流水线.assets/image-20221129183911732.png)



![image-20221129183939922](k8s集群中部署项目之流水线.assets/image-20221129183939922.png)







~~~powershell
pipeline {
  agent {
    node {
      label 'maven'
    }

  }
   parameters {
    string(name: 'PROJECT_VERSION', defaultValue: 'v1.0', description: '')
    string(name: 'PROJECT_NAME', defaultValue: '', description: '')
  }
  
   environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITEE_CREDENTIAL_ID = 'gitee-id'
    KUBECONFIG_CREDENTIAL_ID = 'sangomall-kubeconfig'
    REGISTRY = 'docker.io'
    DOCKERHUB_NAMESPACE = 'nextgomsb'
    GITEE_ACCOUNT = 'nextgomsb'
    SONAR_CREDENTIAL_ID = 'sonar-qube'
  }
 
  
  stages {
    stage('拉取项目代码') {
      agent none
      steps {
        git(url: 'https://gitee.com/nextgomsb/sangomall.git', credentialsId: 'gitee-id', changelog: true, poll: false)
      }
    }

    stage('代码质量检查及分析') {
      agent none
      steps {
        container('maven') {
          withCredentials([string(credentialsId : 'sonar-qube' ,variable : 'SONAR_TOKEN' ,)]) {
            withSonarQubeEnv('sonar') {
              sh 'echo 当前目录 `pwd`'
              sh 'mvn clean install -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
              sh 'mvn sonar:sonar -gs `pwd`/mvn_settings.xml -Dsonar.login=$SONAR_TOKEN'
            }

          }

          timeout(unit: 'HOURS', activity: true, time: 1) {
            waitForQualityGate 'true'
          }

        }

      }
    }

    stage('单元测试') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
        }

      }
    }

    stage('构建项目容器镜像及推送') {
      agent none
      steps {
        container('maven') {
          sh 'mvn clean package -Dmaven.test.skip=true -gs `pwd`/mvn_settings.xml'
          sh 'cd $PROJECT_NAME && docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER .'
          withCredentials([usernamePassword(credentialsId : 'dockerhub-id' ,passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,)]) {
            sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
            sh 'docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest'
            sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:latest'
          }

        }

      }
    }

    stage('创建项目代码及容器镜像的发布版') {
      agent none
      when {
        expression {
          return params.PROJECT_VERSION =~ /v.*/
        }

      }
      steps {
        container('maven') {
          input(message: '''@project-admin  
是否允许推送本次项目代码及容器镜像的发布版？''', submitter: 'project-admin')
          withCredentials([usernamePassword(credentialsId : 'gitee-id' ,passwordVariable : 'GITEE_PASSWORD' ,usernameVariable : 'GITEE_USERNAME' ,)]) {
            sh 'git config --global user.email "nextgo@126.com" '
            sh 'git config --global user.name "nextgo" '
            sh 'git tag -a $PROJECT_VERSION -m "$PROJECT_VERSION" '
            sh 'git push http://$GITEE_USERNAME:$GITEE_PASSWORD@gitee.com/$GITEE_ACCOUNT/sangomall.git --tags --ipv4'
          }

          sh 'docker tag  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:SNAPSHOT-$BUILD_NUMBER $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:$PROJECT_VERSION '
          sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$PROJECT_NAME:$PROJECT_VERSION'
        }

      }
    }

    stage('部署微服务项目到K8S集群') {
      agent none
      steps {
        input(message: '''@project-admin  
是否允许发布微服务项目到K8S集群？''', submitter: 'project-admin')
        container('maven') {
          withCredentials([kubeconfigContent(credentialsId : 'sangomall-kubeconfig' ,variable : 'KUBECONFIG_CONTENT' ,)]) {
            sh '''mkdir ~/.kube
echo "$KUBECONFIG_CONTENT" > ~/.kube/config
envsubst < $PROJECT_NAME/deploy/deploy.yaml | kubectl apply -f -'''
          }

        }

      }
    }

  }
 
}
~~~





![image-20221129184034930](k8s集群中部署项目之流水线.assets/image-20221129184034930.png)







# 十、提交项目中使用所有文件





![image-20221130111251762](k8s集群中部署项目之流水线.assets/image-20221130111251762.png)





![image-20221130111328918](k8s集群中部署项目之流水线.assets/image-20221130111328918.png)





