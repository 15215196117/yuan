#!/usr/bin/env bash
比较非主流的虚拟化软件,许多辣鸡VPS喜欢用这个做虚拟化
优点是配置简单,启动迅速、管理方便
缺点是共享式的虚拟化（号称容器虚拟化）,部分软件无法使用,虚拟机之间隔离不彻底,貌似2.6以上的内核无法安装（貌似没有更新了）
简单安装
环境 单台centos6.5主机
默认目录为/vz 建议单独挂载一块磁盘 虚拟机的存放目录就放在下面（直接就能cd到某个主机的文件系统）
1.关闭selinux SELINUX=disabled
2.增加软件源：wget -P /etc/yum.repos.d/ http://ftp.openvz.org/openvz.repo
3.yum 安装相关组件 yum install -y vzkernel vzctl vzquota ploop
4.更改内核参数
    net.ipv4.ip_forward = 1
    net.ipv6.conf.default.forwarding = 1
    net.ipv6.conf.all.forwarding = 1
    net.ipv4.conf.default.proxy_arp = 0
    # Enables source route verification
    net.ipv4.conf.all.rp_filter = 1
    # Enables the magic-sysrq key
    kernel.sysrq = 1
    # We do not want all our interfaces to send redirects
    net.ipv4.conf.default.send_redirects = 1
    net.ipv4.conf.all.send_redirects = 0
5.重启服务器,开机界面选择openvz 内核 （查看内核会有惊喜）
6.openvz虚拟化和其他不同,不需要单独安装操作系统,官方提供各种操作系统的模板(),开箱即用(有好有坏吧,虚拟化的很假 比如centos7的内核是2.6！！！)
   下载地址：https://openvz.org/Download/template/precreated
7.创建虚拟机
    下载对应操作系统的模板到 /vz/template/cache/
    vzctl create 101 –ostemplate centos-7-x86 #101为主机ID  跟上主机的模板
    vzctl set 101 –ipadd 172.16.10.101 –save #这里貌似没有提供其他的网络隔离方式 直接桥接本机的网络,和本机网络在同一网段
    vzctl set 101 –nameserver 114.114.114.114 –save
    vzctl start 101 #start/stop

    #/etc/vz/conf/101.conf #这个文件存放虚拟机的配置文件（需要增加主机配置 直接更改文件重启虚拟机就行了）
    

