#!/usr/bin/env bash
[ldap]
安装  yum -y install openldap*  db4*  //安装openldap

生成随机加密的密码
slappasswd
New password: 输入密码
Re-enter new password: 再输入密码
生成一个随机的加密密码: {SSHA}YAz5BrA9hdWVv7HM2Yhd2C2erVVI/VVc
备注：相同的数字随机加密后会不同

连接
网上提供web管理界面,根据需要自行配置
也可以使用 LdapAdmin 进行连接管理 下载地址自行google

数据备份恢复有很多种方式 下面是通过命令进行备份
    备份 /usr/sbin/slapcat > /opt/ldap/ldapdbak.ldif  //数据备份
    恢复  slapadd -l /opt/ldap/ldapdbak.ldif  //数据恢复

推荐----也可以直接备份数据文件夹(推荐,更方便直接 需要在配置文件中指定)
        directory       /data/ldap   //这里指定数据存放目录


迁移--这里提供一种比较简单的方法,同mysql的percona-xtrabackup工具原理一致

scp -r /data/ldap <ip>:/data //同步数据文件
scp -r /etc/openldap  <ip>:/etc  //同步配置文件,需要将目标服务器的配置文件夹 move备份
chown -R ldap:ldap /data/ldap  //更改目录权限
chown -R ldap:ldap /etc/openldap
service slapd start //启动服务


[主从同步]
配置文件增加下面内容
syncrepl rid=003
        provider=ldap://120.26.67.225

        # 主库地址
        type=refreshOnly
        retry="60 10 600 +"
        interval=00:00:00:10
        searchbase="dc=55haitao,dc=com"
        scope=sub
        schemachecking=off
        bindmethod=simple
        binddn="cn=Manager,dc=55haitao,dc=com"  #管理员账户
        attrs="*,+"
        credentials=FH759cXBdOTSmpquLz6E	#密码

[参考配置文件]
[root@openvz-morepay ~]# grep -v -E "^#|^$" /etc/openldap/slapd.conf
include         /etc/openldap/schema/corba.schema
include         /etc/openldap/schema/core.schema
include         /etc/openldap/schema/cosine.schema
include         /etc/openldap/schema/duaconf.schema
include         /etc/openldap/schema/dyngroup.schema
include         /etc/openldap/schema/inetorgperson.schema
include         /etc/openldap/schema/java.schema
include         /etc/openldap/schema/misc.schema
include         /etc/openldap/schema/nis.schema
include         /etc/openldap/schema/openldap.schema
include         /etc/openldap/schema/ppolicy.schema
include         /etc/openldap/schema/collective.schema
include         /etc/openldap/schema/radius.schema
include         /etc/openldap/schema/sudo.schema
include         /etc/openldap/schema/openssh-lpk-openldap.schema
include         /etc/openldap/schema/ldapns.schema
include         /etc/openldap/schema/samba.schema
allow bind_v2
pidfile         /var/run/openldap/slapd.pid
argsfile        /var/run/openldap/slapd.args
modulepath /usr/lib/openldap
modulepath /usr/lib64/openldap
moduleload memberof.la
moduleload sssvlv.la
moduleload syncprov.la
database config
access to *
        by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
        by * none
database monitor
access to *
        by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read
        by dn.exact="cn=Manager,dc=juhefu,dc=cn" read
        by * none
database        bdb
suffix          "dc=juhefu,dc=cn"
checkpoint      1024 15
rootdn          "cn=Manager,dc=juhefu,dc=cn"
rootpw {SSHA}kMKw8igxUtknUZniqI04uMsTZtVqGmFi  //slappasswd 生成的密码 安装的时候需要生成
directory       /data/ldap
index objectClass                       eq,pres
index ou,cn,mail,surname,givenname      eq,pres,sub
index uidNumber,gidNumber,loginShell    eq,pres
index uid,memberUid                     eq,pres,sub
index nisMapName,nisMapEntry            eq,pres,sub
index   sudoUser        eq
index entryCSN,entryUUID eq
access to attrs=userPassword
        by self write
        by anonymous auth
        by * none
access to *
        by self write
        by * read
overlay syncprov
syncprov-checkpoint 100 10
syncprov-sessionlog 100

