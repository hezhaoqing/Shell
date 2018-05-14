#!/bin/bash
### cron: 00 01 * * 3 $0

cd /data/shellscripts/J/yml

for i in `ls  |grep yml`
do
	/usr/bin/ansible-playbook $i
done
