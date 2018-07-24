#!/bin/bash
cd /data/sdyxz/client &&
pwd

case $1 in
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
	echo "Invalid argument.   Only p or s."
	;;
esac
