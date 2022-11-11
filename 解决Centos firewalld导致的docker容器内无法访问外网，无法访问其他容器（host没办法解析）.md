# 解决Centos firewalld导致的docker容器内无法访问外网，无法访问其他容器（host没办法解析）

# 开启 NAT 转发
firewall-cmd --permanent --zone=public --add-masquerade

# 检查是否允许 NAT 转发
firewall-cmd --query-masquerade

# 禁止防火墙 NAT 转发
firewall-cmd --remove-masquerad

