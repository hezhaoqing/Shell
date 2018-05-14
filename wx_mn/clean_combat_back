#!/bin/bash

### clean back 90 days ago ###

back_dir=/data/backup

for i in `ls ${back_dir}|grep _server`
do

find ${back_dir}/$i -type f -name "*.tgz" -mtime +90 -exec rm -f {} \;

done
exit 0
