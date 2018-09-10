#!/bin/bash

###  JUST USED FOR CATALINA.OUT  ###

FILE1=/data/tomcat/tomcat-ais8080/logs/catalina.out
FILE2=/data/tomcat/tomcat-ais8088/logs/catalina.out

BACK1=/data/log_back/8080_log
BACK2=/data/log_back/8088_log

DATE=`date +%F`

cp $FILE1 $BACK1/catalina.${DATE}.out && cat /dev/null > $FILE1
cp $FILE2 $BACK2/catalina.${DATE}.out && cat /dev/null > $FILE2



##### clean old back ####

find $BACK1 -type f -name "*.out" -mtime +1 -exec rm -f {} \;
find $BACK2 -type f -name "*.out" -mtime +1 -exec rm -f {} \;
