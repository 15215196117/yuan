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
#恢复数据库  下面2步是必须执行的 网上大多数教程都有点问题~~~
innobackupex --apply-log /data/backup/xxxxxxx
innobackupex --move-back /data/backup/xxxxxxx/
#更改my.cnf添加中继日志
relay_log=/data/mysql/logs/relay-log/relay_log
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



##########################################################分割线#######################################################################
#主从数据一致检查：
#pt-table-checksum 用来检查主从数据是否一致 ，pt-table-sync 用来查看主从数据不一致的地方 并执行
yum install percona-toolkit -y 

先master的ip，用户，密码，然后是slave的ip，用户，密码
#打印不同
#--no-bin-log  默认主从架构为了安全，不能执行 需要添加这个参数
 pt-table-sync --databases=gateway h=10.100.1.216,u=root,p='KbBIHQqhdA9UCGAY' h=172.16.30.113,u=root,p='KbBIHQqhdA9UCGAY' --print --no-bin-log
#执行不同的sql
pt-table-sync --databases=xxx h=127.0.0.1,u=root,p=123456 h=192.168.0.20,u=root,p=123456 --execute

#需要设置binlog 日志的格式
show global variables like 'binlo%'; 
set global binlog_format=STATEMENT;
#更改用户授权
grant all on *.* to gateway@"%" identified by '"53bp2Q"XlguJlk0';
#更改root连接地址 测试完成后再改过来
rename user 'root'@'127.0.0.1' to 'root'@'%';


########cetnos7 安装mysql5.6
yum install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
yum repolist enabled | grep "mysql.*-community.*"
