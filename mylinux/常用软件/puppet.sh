#!/usr/bin/env bash
说明  puppet和saltstack功能感觉上差不多 (就简单的用了一些简单的功能,其他功能没有仔细研究，但是感觉saltstack还是细致点实现的功能比较多)
大致的功能有
    文件同步(文件权限,署主, 用来同步软件的配置文件,常用脚本等 支持变量定义 和saltstack的jinja模板差不多当定义变量后同步文件时会替换相应变量为对应的值)
    软件安装(这个就不用多说了 和文件同步一样都是基础功能 需要的话 请在网上查看相应的例子)
    定时任务
    其他就没有仔细研究了 毕竟就是玩一下 工作场景用不着 (工作中使用saltstack感觉已经足够了 当然puppet还是很强大的)

参考资料：
    http://www.cnblogs.com/fansik/p/5509376.html #基本使用方法
    http://yntmdr.blog.51cto.com/3829621/1592472 #安装

1.安装master端
    yum install puppet puppet-server facter -y
    cat /etc/puppet/puppet.conf
            [main]
            logdir = /var/log/puppet
            rundir = /var/run/puppet
            ssldir = $vardir/ssl
        [agent]
            classfile = $vardir/classes.txt
            localconfig = $vardir/localconfig
        [master]
            certname = k8s-master #新增行 这里设置为主机名 其他的主机需要添加host解析master主机 建议创建主机镜像模板的时候就直接把需要的hosts写到镜像（包括简单的系统优化等）
      systemctl enable puppetmaster
      systemctl start puppetmaster
      systemctl enable puppet && systemctl start puppet
ss -lntp #查看master是否启动 会监听8140 端口

2.安装agent端
yum install puppet facter
grep -v -E '#|^$'  /etc/puppet/puppet.conf

[main]
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = $vardir/ssl
[agent]
    classfile = $vardir/classes.txt
    localconfig = $vardir/localconfig
    certname = k8s-node1 #向master通信的证书名字 类似与saltstack 中的ID 建议直接写成主机名 向master通信后需要master端确定建立相关的证书文件才能正常使用
    server = k8s-master #master的通信地址
    report=true
 systemctl enable puppet &&  systemctl start puppet #设置开机启动并启动程序

3.master 端执行 puppet cert --list --all #查看通信中的客服端 类似于saltstack 中的 salt-key
 puppet cert sign k8s-node1 #生成k8s-node1 的证书 证书文件在 /var/lib/puppet/ssl 下面  "/var/lib/puppet/" 是上面配置文件中$vardir

 agent 执行 puppet agent --test --server=k8s-master ##查看agent是否能正常同行

4.测试puppet

cat /etc/puppet/manifests/site.pp
#默认会优先读取site.pp 文件(同saltstack中的top.sls)  下面代码指定在tmp目录下生成一个内容为test,test 的txt文件
#文件的具体写法就只有去查文档了 看上去挺通俗易懂的
node default {

                    file{"/tmp/123.txt":

                     content=>"test,test";

                             }

}

客服端会生成对应的文件 / 或者客服端执行 puppet agent --test --server=k8s-master 就会生成对应的文件

5.其他
 所有客服端定义在/etc/puppet/manifests/下面 site.pp 为入口文件
 定义模块也在/etc/puppet/ 下面 (感觉目录还是挺清晰的)
 详细介绍参考
        http://www.cnblogs.com/fansik/p/5509376.html

