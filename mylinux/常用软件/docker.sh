#!/usr/bin/env bash
安装
		yum install docker
		docker login registry.aliyuncs.com  #登陆阿里云镜像 更换为国内镜像

		sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://gyw80em4.mirror.aliyuncs.com"]
}
EOF
		sudo systemctl daemon-reload
		sudo systemctl restart docker
		docker run -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker  安装docker web ui

常见用法
		docker images
		docker pull nginx
		docker run -it nginx bash //以交互的方式进入nginx镜像
		docker run -it -rm nginx bash //退出后就直接销毁

		docker run --name merch -it -d -p 8002:7080 tomcat  //创建一个名为merch以tomcat为镜像的容器

将本地的目录挂载到docker下tomcat代码目录
		docker run --name gateway -v /data/app/gateway.ronghexx.com:/usr/local/tomcat/webapps -it -d -p 7080:8080 tomcat
		docker run --name www.juhefu.cn -v /data/app/www.juhefu.cn:/usr/local/tomcat/webapps -it -d -p 8001:8080 tomcat



docker attach 44fc0f0582d9  //进入容器 44fc0f0582d9为容器ID可能存在进不去的问题 建议使用nsenter

使用nsenter
		yum install -y util-linux
将下面脚本写到/usr/local/sbin/docker-enter  //进入容器命令 docker-enter 44fc0f0582d9(id)
#!/bin/sh

if [ -e $(dirname "$0")/nsenter ]; then
  # with boot2docker, nsenter is not in the PATH but it is in the same folder
  NSENTER=$(dirname "$0")/nsenter
else
  NSENTER=nsenter
fi

if [ -z "$1" ]; then
  echo "Usage: `basename "$0"` CONTAINER [COMMAND [ARG]...]"
  echo ""
  echo "Enters the Docker CONTAINER and executes the specified COMMAND."
  echo "If COMMAND is not specified, runs an interactive shell in CONTAINER."
else
  PID=$(docker inspect --format "{{.State.Pid}}" "$1")
  if [ -z "$PID" ]; then
    exit 1
  fi
  shift

  OPTS="--target $PID --mount --uts --ipc --net --pid --"

  if [ -z "$1" ]; then
    # No command given.
    # Use su to clear all host environment variables except for TERM,
    # initialize the environment variables HOME, SHELL, USER, LOGNAME, PATH,
    # and start a login shell.
#"$NSENTER" $OPTS su - root
"$NSENTER" $OPTS /bin/su - root
  else
    # Use env to clear all host environment variables.
    "$NSENTER" $OPTS env --ignore-environment -- "$@"
  fi
fi

一个容器只能有一个进程

端口映射
		docker run --name webserver -d -p 80:80 nginx  //启动nginx镜像命名为websever并将nginx80端口映射到本地80端口
-p指定本地一个端口映射到 docker容器  -P随机映射一个端口到docker容器

docker run -d -p 9100:9100 \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  --net="host" \
  node-exporter \
    -collector.procfs /host/proc \
    -collector.sysfs /host/sys \
    -collector.filesystem.ignored-moun  t-points "^/(sys|proc|dev|host|etc)($|/)"
dockerfile 文件编写
详解:
https://github.com/zhangpeihao/LearningDocker/blob/master/manuscript/04-WriteDockerfile.md