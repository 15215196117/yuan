#!/usr/bin/env bash
consul 常用功能
    1.服务注册
    2.健康检查
    3.dns查询
    4.k/v存储(这个没有用过)
    5.提供webui 查看节点状态
常用命令
agent	运行一个consul agent	consul agent -dev
join	将agent加入到consul集群	consul join IP
members	列出consul cluster集群中的members	consul members
leave	将节点移除所在集群	consul leave

附:生产应用注册脚本---模板

#!/bin/bash
# chkconfig: 2345  80 50
. /etc/rc.d/init.d/functions

ret=0

app_name={{app_name}}

start() {
                echo -n "start $app_name"
                daemon daemonize -a -c /data/app/$app_name/ \
                        -p /var/run/$app_name.pid \
                        -u $app_name \
                        -o /data/logs/app/$app_name.log \
                        -e /data/logs/app/$app_name.log \
                         /data/app/$app_name/bin/catalina.sh run
-
                echo  #服务注册访问api
                /usr/bin/curl -s -X PUT -d '{"name": "{{app_name}}", "enableTagOverride": false, "address":"{{localhost_ip}}", "port": {{app_port}},  "tags":["{{hostname }}"], "checks":[{ "http": "{健康检查地址/应用访问地址 保证服务正常运行}", "interval": "10s","timeout": "1s"}]} ' http://127.0.0.1:8500/v1/agent/service/register

}

stop() {
                   #服务注销api
               /usr/bin/curl -s http://127.0.0.1:8500/v1/agent/service/deregister/{{consul_name}}
			   sleep 10
                echo -n  "stop $app_name"
                killproc -p /var/run/$app_name.pid
                if [ $? -eq 0 ];then
                   rm -rf /var/run/$app_name.pid
                fi
                echo

}


# See how we were called.
case "$1" in
  start)
        status -p /var/run/$app_name.pid > /dev/null 2>&1 && exit 0
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  status)
        status -p /var/run/$app_name.pid
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart}"
        exit 1
esac

exit $ret

