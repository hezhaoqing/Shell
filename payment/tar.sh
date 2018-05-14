1.我们的目录名称以及结构是这样的：

[root@10-xxx 4767140]# ls
20180502.tar.gz  2018050505  2018050513  2018050523  2018050609  2018050617  2018050704  2018050712  2018050723  2018050809  2018050819  2018050907  2018050915  2018051005  2018051013  2018051021  2018051108
20180503.tar.gz  2018050506  2018050514  2018050600  2018050610  2018050618  2018050705  2018050713  2018050801  2018050810  2018050823  2018050908  2018050916  2018051006  2018051014  2018051023  tar.sh
20180504.tar.gz  2018050507  2018050516  2018050602  2018050611  2018050620  2018050706  2018050714  2018050802  2018050811  2018050900  2018050909  2018050917  2018051007  2018051015  2018051100  test.sh
2018050500       2018050508  2018050517  2018050604  2018050612  2018050621  2018050707  2018050715  2018050804  2018050812  2018050901  2018050910  2018050918  2018051008  2018051016  2018051101
2018050501       2018050509  2018050518  2018050605  2018050613  2018050622  2018050708  2018050716  2018050805  2018050813  2018050902  2018050911  2018050919  2018051009  2018051017  2018051103
2018050502       2018050510  2018050519  2018050606  2018050614  2018050623  2018050709  2018050717  2018050806  2018050814  2018050904  2018050912  2018050922  2018051010  2018051018  2018051105
2018050503       2018050511  2018050521  2018050607  2018050615  2018050702  2018050710  2018050718  2018050807  2018050817  2018050905  2018050913  2018051001  2018051011  2018051019  2018051106
2018050504       2018050512  2018050522  2018050608  2018050616  2018050703  2018050711  2018050722  2018050808  2018050818  2018050906  2018050914  2018051002  2018051012  2018051020  2018051107

[root@10-xxx 4767140]# pwd
/data/aisDn/4767140

[root@10-31-55-55 4767140]# tree 2018050500
2018050500
├── 4767140_2018050500_SDGApp6.log
├── 4767140_2018050500_SDGApp6.log.gz
└── cp
    └── 476714001_4767140_2018050500_SDGApp6.log

1 directory, 3 files


2.需求是： 把七天前的当天所有的目录打包为1个文件，并删除对应目录


3.看之前运维留下的脚本，感觉很厉害的样子
[root@10-31-55-55 4767140]# cat tar.sh 
#!/bin/bash

today=`date -d 'now' +%Y%m%d`
yesterday=`date -d 'yesterday' +%Y%m%d`
two_days_ago=`date -d '2 days ago' +%Y%m%d`
three_days_ago=`date -d '3 days ago' +%Y%m%d`
four_days_ago=`date -d '4 days ago' +%Y%m%d`
five_days_ago=`date -d '5 days ago' +%Y%m%d`
six_days_ago=`date -d '6 days ago' +%Y%m%d`
seven_days_ago=`date -d '7 days ago' +%Y%m%d`
#echo $today $yesterday $two_days_ago $three_days_ago
tar_file=`ls|egrep ^[0-9]|egrep [0-9]$|grep -v $today|grep -v $yesterday|grep -v $two_days_ago|grep -v $three_days_ago|grep -v $four_days_ago|grep -v $five_days_ago|grep -v $six_days_ago|grep -v $seven_days_ago`
#echo $tar_file

files=""
for i in $tar_file
do
#        tar zcvf $i.gz $i
		files="${files} ${i}"
        if [ -f $i.gz ]; then
		echo -e $i "tar \033[32;1mSuccess\033[0m"
#                rm -rf $i
		echo -e $i "already \033[31;1mdeleted\033[0m"
        else
                echo -e "Compression \033[31;1mfailed\033[0m" $i
        fi
done
tar zcvf $seven_days_ago.tar.gz $files


for i in $tar_file
do

        if [ -f $seven_days_ago.tar.gz ]; then
		echo -e $i "tar \033[32;1mSuccess\033[0m"
                rm -rf $i
		echo -e $i "already \033[31;1mdeleted\033[0m"
        else
                echo -e "Compression \033[31;1mfailed\033[0m" $i
        fi



4.我修改了一下

[root@10-31-55-55 4767140]# cat test.sh 
#!/bin/bash

seven_days_ago=`date -d '7 days ago' +%Y%m%d`

ls | grep $seven_days_ago |grep -v gz$|xargs tar czvf $seven_days_ago.tar.gz

if [ -f $seven_days_ago.tar.gz ]; then
	ls | grep $seven_days_ago |grep -v gz$|xargs rm -rf
fi

