#!/usr/bin/env bash
LVM是 Logical Volume Manager(逻辑卷管理)
lvm动态分配磁盘扩容.缩小
安装软件 yum install lvm2 xfsprogs -y
fdisk -l #查看新增的设备
pvcreate