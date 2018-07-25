#!/bin/bash

if [ $# != 2 ];then
        echo -e "\033[31m Need two arguments. \033[0m"
        exit 1
elif [ $1 == tg ];then
        cd /data/sdyxz/client && pwd
elif [ $1 == yn ];then
        cd /data/sdyxzVN/client && pwd
elif [ $1 == yd ];then
        cd /data/sd2/client && pwd
else
        echo -e "\033[31m Invalid argument. \$1: Only tg or yn. \033[0m"
	exit 1
fi


case $2 in
	p)
for i in `diff iOS/ test/iOS/ |grep "Only in test/iOS/"|grep iOS_ |awk '{print $NF}'`
do
	cp test/iOS/$i iOS/
	ls -l iOS/$i
done

\cp test/iOS/patchlist.xml iOS/                                ### 不用加-f,也可以强制覆盖。
ls -l iOS/patchlist.xml

sleep 1

for j in `diff Android/ test/Android/ |grep "Only in test/Android/"|grep Android_ |awk '{print $NF}'`
do
        cp test/Android/$j Android/
	ls -l Android/$j
done

\cp test/Android/patchlist.xml Android/
ls -l Android/patchlist.xml
;;
	s)
	\cp test/Android/serverlist.xml Android/
	\cp test/iOS/serverlist.xml iOS/
	ls -l Android/serverlist.xml
	ls -l iOS/serverlist.xml
	;;

	*)
	echo -e "\033[31m Invalid argument. \$2: Only p or s. \033[0m"
	exit 1
	;;
esac

echo -e "\033[32m Update completed, please flush CDN. \033[0m"
