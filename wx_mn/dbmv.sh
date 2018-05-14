#!/bin/bash

for i in `ls /home/|grep a_mix`
do
        dbserverbak=/home/$i/backup/dbserver_*
        mvdir=/data/dbserverbak/$i

        if [ ! -d $mvdir ]; then
                mkdir -p $mvdir
                mv $dbserverbak $mvdir
        else
                mv $dbserverbak $mvdir
        fi
done

exit 0
