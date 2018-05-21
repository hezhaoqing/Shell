#!/bin/bash

var=`date +%F" "%T`

DIR=/data/shellscripts

#### record top ####
/usr/bin/top -b -d 1 -n 1 |head -11 >> $DIR/top.`date +%F`.txt


#### record java mysql io ####
echo "$var" >> $DIR/java.`date +%F`.txt && ps aux |grep java|grep -v grep  >> $DIR/java.`date +%F`.txt 

echo "$var" >> $DIR/mysql.`date +%F`.txt && ps aux |grep mysql | grep -v grep  >> $DIR/mysql.`date +%F`.txt

echo "$var" >> $DIR/io.`date +%F`.txt && iostat >> $DIR/io.`date +%F`.txt


#### keep them for 7 days ####
find $DIR -type f -name "*.txt" -mtime +7 -exec rm -f {} \;
