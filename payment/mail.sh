#!/bin/bash

DATE=`date +%F`

sleep 30

awk '/service\/sub/ {print $0}' /data/nginx/logs/subapi.access.${DATE}.log |awk -F " |=|&|%22" '{print $1"   "$8"   "$10"   "$19"   "$23}' |sort |uniq -c|sort -nr|awk '{if($1 >= 3) {print $0}}' |mail -s "$DATE" hezhaoqing@freeg.cn


awk '/service\/sub\/th/ {print $1}' /data/nginx/logs/subapi.access.${DATE}.log |sort -n |uniq -c |wc -l | mail -s "$DATE.有效访问数量" zhuoran@freeg.cn
