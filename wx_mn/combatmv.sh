#!/bin/bash

####  include the worldserver and combatserver ####

for i in `ls /home/|grep _server`
do
        serverbak=/home/$i/backup/*_dirbinlogs.tgz
        mvdir=/data/backup/$i

        if [ ! -d $mvdir ]; then
                mkdir -p $mvdir
                mv $serverbak $mvdir
        else
                mv $serverbak $mvdir
        fi
done
exit 0
