#!/bin/bash

### clean gameserver back 90 days ago ###

back_dir=/data/gameserverbak

for i in `ls ${back_dir}|grep a_mix`
do

find ${back_dir}/$i -type f -name "*.tgz" -mtime +90 -exec rm -f {} \;

done
exit 0
