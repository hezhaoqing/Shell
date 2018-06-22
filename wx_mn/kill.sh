#!/bin/bash
### what a fuck ###

while true;
do

NUM=`/usr/bin/top -b -d 1 -n 1 | awk '{if ($9 > 200) {print $1}}' |grep -v top |grep -v Tasks|grep -v Mem|grep -v Swap|wc -l`
PPPNUM=`/usr/bin/top -b -d 1 -n 1 | awk '{if ($9 > 200) {print $1}}' |grep -v top |grep -v Tasks|grep -v Mem|grep -v Swap`

if [ $NUM = 1 ];then
	kill -9 $PPPNUM
fi

sleep 3

done
