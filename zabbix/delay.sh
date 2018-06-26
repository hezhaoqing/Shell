#!/bin/bash

IP=$1
ping $IP -c 1 |awk '/avg/{print $4}'|awk -F "/" '{print $2}'



UserParameter=ping.lost[*],/data/shellscripts/zabbix/lost.sh $1
UserParameter=ping.delay[*],/data/shellscripts/zabbix/delay.sh $1
#UserParameter=tailand.ais.delay.202.149.27.36,ping 202.149.27.36 -c 1 | awk '/avg/{print $4}' |awk -F "/" '{print $2}'
#UserParameter=tailand.true.delay.61.91.213.202,ping 61.91.213.202 -c 1 | awk '/avg/{print $4}' |awk -F "/" '{print $2}'
#UserParameter=tailand.dtac.delay.202.91.22.158,ping 202.91.22.158 -c 1 | awk '/avg/{print $4}' |awk -F "/" '{print $2}'
#UserParameter=vn.fpt.delay.42.112.28.116,ping 42.112.28.116 -c 1 | awk '/avg/{print $4}' |awk -F "/" '{print $2}'
#UserParameter=vn.vnpt.delay.123.29.68.206,ping 123.29.68.206 -c 1 | awk '/avg/{print $4}' |awk -F "/" '{print $2}'
#UserParameter=vn.cmc.delay.103.21.150.23,ping 103.21.150.23 -c 1 | awk '/avg/{print $4}' |awk -F "/" '{print $2}'
