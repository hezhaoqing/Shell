#!/bin/bash
WORKSPACE=$(cd $(dirname $0)/; pwd)
cd $WORKSPACE
source /etc/profile
start_day="2018-03-01 00:00"
end_day="2018-03-01 03:55"
start_sec=`date -d "$start_day" +%s`
end_sec=`date -d "$end_day" +%s`

while true
do
  date1=$(date -d"@$start_sec" +"%Y%m%d")
  date2=$(date -d"@$start_sec" +"%Y%m%d")
  start=$(date -d"@$start_sec" +"%H%M")
  let start_sec+=300
  end=$(date -d"@$start_sec" +"%H%M")
  if [ $start -eq 2355 ];then
     date2=`date -d "$date1 1 days" +%Y%m%d`
  fi
  echo "./start.cdn.zhanqi.job5min.sh $date1/$start $date2/$end"
  #./start.cdn.zhanqi.job5min.sh $date1/$start $date2/$end
  if [ $start_sec -gt $end_sec ]
  then
  break;
  fi
done
exit
