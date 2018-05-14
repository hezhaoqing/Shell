#!/bin/bash

### used for monitoring the blackip.sh's status ###

NUM=`ps -ef |grep blackip.sh |grep -v grep |wc -l`

if [ $NUM -eq 0  ];then
	sh /data/shellscripts/blackip.sh & >> /dev/null 2>&1
fi
