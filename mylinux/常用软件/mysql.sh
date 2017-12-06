#!/usr/bin/env bash
1.线上拉取备份,并解压到mysql的数据文件目录，
2.更改用户组和用户，mysql_server_id

master:操作
#授权用户slave
 grant replication slave on *.* to 'slave'@'10.10.%' identified by '~aTz#q4D&SvXkZsI';
#查看并记录master相关的值 binlog_file 及 position
show master status;
#使用innobackupex 备份数据库
innobackupex  --password=$PASSWORD --user=$USER --host=$HOST --port=$PORT --stream=tar $TO/$HOSTNAME-db-$date | gzip > $TO/$HOSTNAME-db-$date.tgz
#会生成相关的binlog和position信息（重要）

#python启动一个httpserver 用来下载备份文件
python -m SimpleHTTPServer 8080 


 slave:操作
 #新增vpn连接到主库
 echo "openconnect -b -u {youname} --no-dtls --no-cert-check --reconnect-timeout 900 https://sh-sa.vpn.xxxxxxx.com:1443 --passwd-on-stdin <<<{youpassword}" >>/etc/rc.d/rc.local
#下载主库上的备份文件,并解压
wget http://xxxxxxx
#安装percona工具
yum install percona-xtrabackup -y
#恢复数据库
innobackupex --copy-back /data/backup/xxxxxxx/
#更改数据库目录权限
chwon -R mysql:mysql /data/mysql
#启动mysql \
service mysql start


# 配置连接主库  master_log_file和master_log_pos 查找数据库文件目录下的xtrabackup_info
#比如这里的 cat /data/mysql/data/xtrabackup_info 
change master to
master_host='10.10.3.2',
master_port=3306,
master_user='slave',
master_password='~aTz#q4D&SvXkZsI',
master_log_file='xxxxx',
master_log_pos=xxxxx;

#启动slave
start slave
#查看状态
show slave status \G
#重要状态说明
#Slave_IO_Running: Slave_SQL_Running 都必须是YES 
#pos的值两边必须要一致 从库和主库必须一致 才能表明两边数据是一致的 
Slave_IO_State: Waiting for master to send event
Master_Host: 10.10.3.2  #主库地址
Master_User: slave
Master_Port: 3306
Connect_Retry: 60 #拉取间隔
Master_Log_File: log_bin.000078 #master binlogfile文件
Read_Master_Log_Pos: 13288408  #读取master的pos
Relay_Log_File: mysqld-relay-bin.000004
Relay_Log_Pos: 4469
Relay_Master_Log_File: log_bin.000078
Slave_IO_Running: Yes #读取master的二进制日志
Slave_SQL_Running: Yes #将中继日志换成SQL语句后执行
Replicate_Do_DB: 
Replicate_Ignore_DB: 
Replicate_Do_Table: 
Replicate_Ignore_Table: 
Replicate_Wild_Do_Table: 
Replicate_Wild_Ignore_Table: 
Last_Errno: 0
Last_Error: 
Skip_Counter: 0
Exec_Master_Log_Pos: 13288408  #执行读取master的pos 




