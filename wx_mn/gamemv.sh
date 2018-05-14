#!/bin/bash

for i in `ls /home/|grep a_mix`
do
        gameserverbak=/home/$i/backup/gameserver_*
        mvdir=/data/gameserverbak/$i

        if [ ! -d $mvdir ]; then
                mkdir -p $mvdir
                mv $gameserverbak $mvdir
        else
                mv $gameserverbak $mvdir
        fi
done

### for ansible playbook ###
exit 0
