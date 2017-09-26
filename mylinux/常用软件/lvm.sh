#!/usr/bin/env bash
LVM是 Logical Volume Manager(逻辑卷管理)
lvm动态分配磁盘扩容.缩小
安装软件 yum install lvm2 xfsprogs -y
fdisk  -l #查看新增的设备 比如
        Disk /dev/vdb: 107.4 GB, 107374182400 bytes, 209715200 sectors
        Units = sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes

pvcreate /dev/vdb #创建PV
              --- Physical volume ---
              PV Name               /dev/vdb
              VG Name               morepay
              PV Size               100.00 GiB / not usable 4.00 MiB
              Allocatable           yes (but full)
              PE Size               4.00 MiB
              Total PE              25599
              Free PE               0
              Allocated PE          25599
              PV UUID               kOLhob-RYWj-g0bJ-B4oz-xcRg-10eG-jBymIF

vgcreate morepay /dev/vdb #创建VG
              --- Volume group ---
              VG Name               morepay
              System ID
              Format                lvm2
              Metadata Areas        1
              Metadata Sequence No  6
              VG Access             read/write
              VG Status             resizable
              MAX LV                0
              Cur LV                1
              Open LV               1
              Max PV                0
              Cur PV                1
              Act PV                1
              VG Size               <100.00 GiB
              PE Size               4.00 MiB
              Total PE              25599
              Alloc PE / Size       25599 / <100.00 GiB
              Free  PE / Size       0 / 0
              VG UUID               Y5ech7-Lwsm-bucm-38uB-M3Wy-99pS-6i8de0

lvcreate -l 100%VG  -n data morepay #创建LV  -n data 命名为创建的盘为data
              --- Logical volume ---
              LV Path                /dev/morepay/data
              LV Name                data
              VG Name                morepay
              LV UUID                E4RC9W-sieE-HQZc-InEJ-e4Td-LEPr-adFu43
              LV Write Access        read/write
              LV Creation host, time gitlab, 2017-09-15 05:15:51 -0400
              LV Status              available
              # open                 1
              LV Size                <100.00 GiB
              Current LE             25599
              Segments               1
              Allocation             inherit
              Read ahead sectors     auto
              - currently set to     8192
              Block device           253:1


mkfs.xfs /dev/mapper/morepay-data #格式化硬盘
        meta-data=/dev/mapper/morepay-data isize=512    agcount=4, agsize=6553344 blks
                 =                       sectsz=512   attr=2, projid32bit=1
                 =                       crc=1        finobt=0, sparse=0
        data     =                       bsize=4096   blocks=26213376, imaxpct=25
                 =                       sunit=0      swidth=0 blks
        naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
        log      =internal log           bsize=4096   blocks=12799, version=2
                 =                       sectsz=512   sunit=0 blks, lazy-count=1
        realtime =none                   extsz=4096   blocks=0, rtextents=0


mount /dev/mapper/morepay-data  /data/
#/etc/fstab 添加开机挂载项
        /dev/vda1            /                    ext3       noatime,acl,user_xattr 1 1
        proc                 /proc                proc       defaults              0 0
        sysfs                /sys                 sysfs      noauto                0 0
        debugfs              /sys/kernel/debug    debugfs    noauto                0 0
        devpts               /dev/pts             devpts     mode=0620,gid=5       0 0
        /dev/mapper/ronghexx-data       /data   xfs             defaults        0 0 #此处为lvm新增挂载盘
        10.10.4.2:/data/nfsserver             /data/nfs       nfs     defaults        0 0 #此处是nfs添加的挂载



