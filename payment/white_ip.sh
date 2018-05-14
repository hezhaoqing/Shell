#!/bin/bash

for i in `cat /data/nginx/white.txt`

do
	grep $i /data/nginx/conf.d/black.conf && sed -i '/${i}/d' /data/nginx/conf.d/black.conf && /data/nginx/sbin/nginx -s reload

done
