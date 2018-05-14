#!/bin/bash

NGINX_CMD=/data/nginx/sbin/nginx

ACCESS_LOG=/data/nginx/logs/subapi.access.log

NEW=/data/nginx/new.txt

OLD=/data/nginx/old.txt

TOTAL=/data/nginx/total.txt

NGINX_FILE=/data/nginx/conf.d/black.conf

INTERVAL=10


while true;

do
	DATE=`date +%F" "%T`

        awk '/\/service\/sub\/th/ {print $1}' $ACCESS_LOG |sort|uniq -c |sort -nr | awk '{if($1 >= 3) {print "deny " $2";"}}' > $NEW

        [ $(grep -v -f $OLD $NEW |wc -l) -gt 0 ] &&

        echo "$(grep -v -f $OLD $NEW)" >> $NGINX_FILE &&

	echo "" >> $TOTAL &&

	echo $DATE >> $TOTAL &&

	echo "$(grep -v -f $OLD $NEW)" >> $TOTAL &&
	
        cat $NEW > $OLD &&

        $($NGINX_CMD -s reload)>> /dev/null 2>&1

        sleep $INTERVAL

done
