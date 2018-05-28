#!/bin/sh 
# crontab: 0 3 * * * /root/mysql_backup.sh >> /data/MysqlBackup/mysql_backup.log 2>&1

# Database info
DB_USER=root
DB_PASS="xxxxxxxx"
DB_NAME=`mysql -u$DB_USER -p$DB_PASS -e "show databases;" | grep -v test | grep -v information_schema | grep -v Database | grep -v mysql`

# Others vars
BACKUP_DIR=/data/MysqlBackup
DATE=`date +%Y%m%d_%H%M`
LOGFILE=$BACKUP_DIR/mysql_backup_`date +%Y%m%d`.log
mysqldump=`which mysqldump`
ip=`ifconfig | awk -F: '{print $2}' | head -2 | tail -1 | awk '{print $1}'`
mailtolist="xxxxx@qq.com"

# backup dir
if [ ! -d $BACKUP_DIR ];then
	mkdir -p $BACKUP_DIR
fi

echo "----------------------------------------" >> $LOGFILE
echo `date -d "now" "+%Y-%m-%d %H:%M:%S"` >> $LOGFILE

# mysqldump
cd $BACKUP_DIR
for x in ${DB_NAME[*]}

do
  
	echo "------------------------backup $x------------------------"
	$mysqldump -u$DB_USER -p$DB_PASS $x  > ${x}_$DATE.sql
	
    if [[ $? == 0 ]]; then
		  gzip ${x}_$DATE.sql		
		  echo "$BACKUP_DIR/${x}_$DATE.sql.gz Backup Success!"  | tee -a $LOGFILE	
    else
		  gzip ${x}_$DATE.sql	 && mv ${x}_$DATE.sql.gz ${x}_error_$DATE.sql.gz
		  echo "$BACKUP_DIR/${x}_error_$DATE.sql.gz Backup Fail!" | tee -a $LOGFILE	
		  message="PROBLEM: mysql backup Fail !!! \nip: $ip \ndate: $DATE \ndatabase: $x \nfilename: $BACKUP_DIR/${x}_error_$DATE.sql.gz"
		  echo -e $message | /bin/mailx -s 'PROBLEM: mysql backup Fail' $mailtolist
    fi
	
	echo  | tee -a $LOGFILE	
	
done

echo "mysql backup done"

#find $BACKUP_DIR -name "*.gz" 		 -mtime +30 -type f  | xargs rm -f
#find $BACKUP_DIR -name "*.log" 		 -mtime +30 -type f  | xargs rm -rf
#find $BACKUP_DIR -name "*error*.sql" -mtime +30 -type f  | xargs rm -rf
