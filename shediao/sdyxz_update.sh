#!/bin/bash

if [ $# != 2 ];then
        echo "Need two arguments."
        exit 1
elif [ $1 == tg ];then
        cd /data/sdyxz/client && pwd
elif [ $1 == yn ];then
        cd /data/sdyxzVN/client && pwd
elif [ $1 == yf ];then
        cd /data/sd2/client && pwd
else
        echo "Invalid argument. \$1: Only tg yn or yf."
	exit 1
fi


case $2 in
	p)
for i in `diff iOS/ test/iOS/ |grep "Only in test/iOS/"|grep iOS_ |awk '{print $NF}'`
do
	cp test/iOS/$i iOS/
done

\cp test/iOS/patchlist.xml iOS/                               ### 不用加-f,也可以强制覆盖。

sleep 1

for j in `diff Android/ test/Android/ |grep "Only in test/Android/"|grep Android_ |awk '{print $NF}'`
do
        cp test/Android/$j Android/
done

\cp test/Android/patchlist.xml Android/
;;
	s)
	\cp test/Android/serverlist.xml Android/
	\cp test/iOS/serverlist.xml iOS/
	;;

	*)
	echo "Invalid argument. \$2: Only p or s."
	;;
esac
