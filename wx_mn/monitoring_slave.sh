#!/bin/bash

KEY1=`mysql -uroot -pxxxxxx -e "show slave status\G" |grep IO_Running |awk '{print $2}'`

KEY2=`mysql -uroot -pxxxxxx -e "show slave status\G" |grep SQL_Running |awk '{print $2}'`

IP=`ip a |awk '/inet 10.*/{print $2}'|awk -F "/" '{print $1}'`

mail()
{
	echo "WARNIGN: $IP: slave is problem !" | mail -s "WARNING" hezhaoqing@freeg.cn
}


if [[ $KEY1 == "No" ]];then
	mail
elif [ $KEY2 == "No" ];then
	mail
else
	exit 0
fi
