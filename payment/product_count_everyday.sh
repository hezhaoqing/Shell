#!/bin/bash

###  you need give three args

###  usage : ./count.sh   sc   kw    logname

###  like this : ./count.sh 4542900 A1 subapi.access.log


TOTAL_ACCESS=`grep "sc=$1" /data/nginx/logs/$3 |grep "kw=$2" |wc -l`

JUMP=`grep "sc=$1" /data/nginx/logs/$3 |grep "kw=$2" |awk '/service\/sub\/th/ {print $0}'|wc -l`

NO_JUMP=`grep "sc=$1" /data/nginx/logs/$3 |grep "kw=$2" |awk '/service\/subapi/ {print $0}'|wc -l`

VALID_ACCESS=`grep "sc=$1" /data/nginx/logs/$3 |grep "kw=$2" |awk '/service\/sub\/th/ {print $0}'| awk '/ 302 / {print $0}' |wc -l`·

INVALID_ACCESS_404=`grep "sc=$1" /data/nginx/logs/$3 |grep "kw=$2" | awk '/service\/sub\/th/ {print $0}'| awk '/ 404 / {print $0}' |wc -l`

INVALID_ACCESS_403=`grep "sc=$1" /data/nginx/logs/$3 |grep "kw=$2" | awk '/service\/sub\/th/ {print $0}'| awk '/ 403 / {print $0}' |wc -l`

echo "总计访问次数： $TOTAL_ACCESS"

echo ""

echo "未跳转访问次数：$NO_JUMP"

echo ""

echo "跳转访问次数：$JUMP"

echo ""

echo "有效访问次数：$VALID_ACCESS"

echo ""

echo "404无效访问次数：$INVALID_ACCESS_404"

echo ""

echo "403无效访问次数：$INVALID_ACCESS_403"

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
效果 ：
[root@10-8-25-35 logs]# ./count.sh 4767101 A9 subapi.access.2018-05-07.log 
总计访问次数： 1115

未跳转访问次数：539

跳转访问次数：576

有效访问次数：480·

404无效访问次数：60

403无效访问次数：0
