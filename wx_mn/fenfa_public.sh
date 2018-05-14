#!/bin/bash

## used to distribute public keys to a lot of machines for the first time.

which expect

if [ $? == 1 ];then
	yum install -y expect
fi

for i in `cat /data/shellscripts/J/ip.txt`

do
	sh /data/shellscripts/J/expect.sh $i >> /dev/null 2>&1
done
