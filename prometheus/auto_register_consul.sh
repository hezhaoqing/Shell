#!/bin/bash 

all_IP=`cat /opt/shellscripts/ip.txt`
name=node-exporter
port=9100

for  i  in ${all_IP}
do	
	curl -X PUT -d '{"id": "'$i'","name": "'$name'","address": "'$i'","port": '$port',"tags": ["sd_node_exporter"], "checks": [{"http": "http://'$i':'$port'/","interval": "5s"}]}' http://127.0.0.1:8500/v1/agent/service/register
done
