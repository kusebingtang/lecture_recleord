# k8s的容器pod的状态为evicted如何处理？

发现很多pod的状态为`evicted`。
**eviction**，即驱赶的意思，意思是当节点出现异常时，[kubernetes](https://so.csdn.net/so/search?q=kubernetes&spm=1001.2101.3001.7020)将有相应的机制驱赶该节点上的Pod。
**多见于资源不足时导致的驱赶**。
排查资源和异常原因，防止新的驱赶产生。
使用如下命令删除旧驱赶的遗留

```sh
kubectl get pods -n kube-public | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n kube-public

```

- cat /data/alarm/del_evicted_pod.sh

```shell

#!/bin/bash
which jq || yum install jq -y 
/opt/kubernetes/bin/kubectl get pods -A |grep Evicted && /opt/kubernetes/bin/kubectl get pods --all-namespaces -o json | /usr/bin/jq -r '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | .metadata.name + " " + .metadata.namespace' | xargs -n2 -l /usr/bin/bash -c '/opt/kubernetes/bin/kubectl delete pods $0 --namespace=$1'

```



# k8s服务故障，出现大量的Evicted状态的pod

```
kubectl describe pod -n op-web zg-web-v470-68dc57b75f-xtwkc
```



```ABAP
Name:           zg-web-v470-68dc57b75f-xtwkc
Namespace:      op-web
Priority:       0
Node:           k8s-node007/
Start Time:     Fri, 17 Jun 2022 09:09:31 +0800
Labels:         app=zg-web-v470
                pod-template-hash=68dc57b75f
Annotations:    <none>
Status:         Failed
Reason:         Evicted
Message:        Pod The node had condition: [DiskPressure]. 
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/zg-web-v470-68dc57b75f
Containers:
  app:
    Image:      registry.cn-hangzhou.aliyuncs.com/lightup/light-zg-web:SNAPSHOT-470
    Port:       8080/TCP
    Host Port:  0/TCP
    Limits:
      memory:  2Gi
    Requests:
      memory:  2Gi
    Environment:
      PARAMS:  --server.port=8080 --spring.profiles.active=k8s-prod
    Mounts:
      /etc/localtime from host-time (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-rmq5h (ro)
Volumes:
  host-time:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/localtime
    HostPathType:  
  kube-api-access-rmq5h:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age   From               Message
  ----     ------     ----  ----               -------
  Normal   Scheduled  40m   default-scheduler  Successfully assigned op-web/zg-web-v470-68dc57b75f-xtwkc to k8s-node007
  Warning  Evicted    40m   kubelet            The node had condition: [DiskPressure].
```



```
Status:         Failed
Reason:         Evicted
Message:        Pod The node had condition: [DiskPressure]. 
```

#### 看磁盘果然发现满了，首先清理一波磁盘空间



```
kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete pods \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c

```



```
kubectl get pods -n op-web | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n op-web
```



docker container prune





还需要把evicted的pod给删掉，由于每个命名空间下都有，所有需要使用脚本循环操作，如下：

```shell

for ns in `kubectl get ns | awk 'NR>1{print $1}'`
do
      kubectl get pods -n ${ns} | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n ${ns}
done

```

