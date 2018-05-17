#!/bin/bash
#用来生成服务器字典


declare -i i=1
declare -i j=1

file=pythonscripts/conf.py
echo -e "#!/bin/env python
# -*- coding: utf_8 -*-



info = {
    'host':{   " > $file



echo -e "       'gameserver':{"  >> $file 
while read worldip; do	
	if [ "$worldip" != "" ]; then
		if   [ $i -ge 0 -a $i -lt 10 ];then 
			echo -e "           'i_jituo_0$i':'$worldip'," >> $file
		else
			echo -e "           'i_jituo_$i':'$worldip'," >> $file
		fi
		let i+=1
	fi
	
done < gameserverip.txt

echo -e "       },"  >> $file 

echo -e "       'dbserver':{"  >> $file
while read dbip; do	
	if [ "$dbip" != "" ]; then
		if   [ $j -ge 0 -a $j -lt 10 ];then 
			echo -e "           'i_jituo_0$j':'$dbip'," >> $file
		else
			echo -e "           'i_jituo_$j':'$dbip'," >> $file
		fi
		let j+=1
	fi
	
done < gamedbip.txt


echo -e "       }
    }
}" >> $file
