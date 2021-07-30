#!/bin/bash
# yum -y install gcc perl-ExtUtils-MakeMaker
# yum -y install ncurses-devel
yum -y install git
yum update -y nss curl libcurl
yum -y install zsh
chsh -s /bin/zsh
chmod 777 /root/on_my_zsh/install.sh
export https_proxy=http://192.168.1.201:7890 http_proxy=http://192.168.1.201:7890 all_proxy=socks5://192.168.1.201:7890
sh /root/on_my_zsh/install.sh
