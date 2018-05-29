#!/bin/bash

UMA=`ls ~ |grep uma-1.1.3-1.i386.rpm |wc -l`

if [ $UMA == 0 ];then
	cd ~ &&
	wget http://umon.api.service.ucloud.cn/static/umatest/uma-1.1.3-1.i386.rpm &> /dev/null &&
	rpm -ivh uma-1.1.3-1.i386.rpm &> /dev/null &&
	service uma start
else
	echo "uma is already installed."
fi
