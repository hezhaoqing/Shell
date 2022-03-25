[root@txy-sh2-epl-backend-prod1 shellscripts]# cat manage_prometheus_push.sh
#!/bin/bash

ps -ef |grep -v grep |grep 'bash prometheus_push.sh' &&  exit 0


cd /opt/shellscripts  && \
nohup bash prometheus_push.sh &
