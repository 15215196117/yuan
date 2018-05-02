#!/usr/bin/env bash

rabbitmqctl add_user juhefu "password"  //新增用户juhefu
rabbitmqctl set_user_tags juhefu administrator  //设置用户tag
 rabbitmqctl help  set_permissions 
rabbitmqctl set_permissions -p / juhefu '.*' '.*' '.*'  //设置用户权限，这里设置/(根目录) 所有权限

rabbitmq-plugins enable rabbitmq_management  //开启web管理界面 rabbitmq-plugins版本不同不一定在bin目录下面

