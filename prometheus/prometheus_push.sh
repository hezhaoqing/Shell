#!/bin/bash
#####

myip=`ip a |awk '/global eth0/{print $2}'|awk -F "/" '{print $1}'`
pgwip='10.0.2.10'
job='node_export-txynw'


while true;

do
        curl 127.0.0.1:9100/metrics |curl --data-binary @- http://$pgwip:9091/metrics/job/$job/instance/$myip  >> /dev/null 2>&1

        sleep 14

done

