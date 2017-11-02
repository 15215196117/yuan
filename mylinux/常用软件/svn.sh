#!/usr/bin/env bash
svn log webapps
svn info webapps
svn st webapps #查看版本控制的文件，配置文件等
#A 新增 C 冲突 D 删除 G 合并 U 更新 E 存在 R 替换 ?未受版本控制

svn up -r {版本号} 更新到指定版本

INSERT INTO services (project_name, net_type, host_port, docker_port, mount, health, pod, env, registry, description) VALUES (project_name=cashier, net_type=link, host_port=6080, docker_port=8080, mount=, health=, pod=, env=1, registry=registry-dev.morepay.cn/morepay/qlk-web-cashier:4522 description=)
