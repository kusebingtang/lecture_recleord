#!/bin/bash
yum -y install gcc perl-ExtUtils-MakeMaker
yum -y install ncurses-devel
yum -y install git
yum update -y nss curl libcurl
yum -y install zsh
chsh -s /bin/zsh
chmod 777 /root/on_my_zsh/install.sh
sh /root/on_my_zsh/install.sh
