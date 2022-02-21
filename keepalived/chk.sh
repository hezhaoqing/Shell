1.简单版本
# 
#!/bin/bash
#
if [ $(ps -C nginx --no-header | wc -l) -eq 0 ]; then
       service keepalived stop
fi


2.常用版本
# 
#!/bin/bash
#
if [ $(ps -C nginx --no-header | wc -l) -eq 0 ]; then
       /usr/local/nginx/sbin/nginx
       sleep 1
       if [ $(ps -C nginx --no-header | wc -l) -eq 0 ]; then
              service keepalived stop
       fi
fi
