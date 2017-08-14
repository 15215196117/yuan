#!/bin/bash
# MYSQL_CON="/usr/local/mysql/bin/mysql"
nowtime=`date`
HOME="/data/bin/crontab/"
TIME=600
OLD_QUERY=`mysql --defaults-file=$cnf --socket=/var/run/mysqld/mysql.sock  -e "show global status like 'questions';" | awk -F[' ','s'] 'NR==2{print $3}'`
echo "$OLD_QUERY"
sleep "$TIME"s
NEW_QUERY=`mysql --defaults-file=$cnf --socket=/var/run/mysqld/mysql.sock -e  "show global status like 'questions';" | awk -F[' ','s'] 'NR==2{print $3}'`
Threads=`mysql --defaults-file=$conf --socket=/var/run/mysqld/mysql.sock -e "show global status like 'Threads_connected';" | awk 'NR==2{print $2}'`
# echo "$NEW_QUERY"
TIME_QUERY=`expr $NEW_QUERY - $OLD_QUERY`
QPS=`expr $TIME_QUERY / $TIME`
echo "$nowtime 当前qps:$QPS" >> $HOME/qps.log
echo "$nowtime 当前连接数 $Threads" >> $HOME/Threads_connected.log


[client]
password=IK0J8OjY9Ju09Ju98
user=zms
socket=/var/run/mysqld/mysql.sock