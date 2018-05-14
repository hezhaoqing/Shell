#!/bin/bash
### cron: 59 23 * * * /bin/bash $0 ###

ACCESS_LOG=/data/nginx/logs/subapi.access.log

LOG_BACK=/data/nginx/logs

DATE=`date +%F`

NGINX_CMD=/data/nginx/sbin/nginx

NGINX_FILE=/data/nginx/conf.d/black.conf

NGINX_DIR=/data/nginx


### cut nginx access log once a day ###

mv $ACCESS_LOG $LOG_BACK/subapi.access.${DATE}.log &&

##$($NGINX_CMD -s reload)

### save the record of access ###

##cat $NGINX_DIR/old.txt >> $NGINX_DIR/total.txt

### clean the blacklist everyday ###

#sleep 60

cat /dev/null > $NGINX_FILE && 

$($NGINX_CMD -s reload)

#cat /dev/null > $NGINX_DIR/old.txt

### black list once a day ###

cp $NGINX_DIR/total.txt $NGINX_DIR/total.${DATE}.txt &&

cat /dev/null > $NGINX_DIR/total.txt
