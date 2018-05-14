#!/bin/bash

### clean db_back 90 days ago ###

back_dir=/data/dbserverbak

for i in `ls ${back_dir}|grep a_mix`
do

find ${back_dir}/$i -type f -name "*.tgz" -mtime +90 -exec rm -f {} \;

done
###
find /data/MaintenanceMysqlBackup -type f -mtime +90 -exec rm -f {} \;
exit 0
