#!/bin/bash
#####

while true;

do
        curl 127.0.0.1:9100/metrics |curl --data-binary @- http://192.168.0.247:9091/metrics/job/node_export-alynw/instance/192.168.0.245  >> /dev/null 2>&1

        sleep 10

done

