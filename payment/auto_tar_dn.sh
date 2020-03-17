#!/bin/bash

for i in `ls /data/aisDn/`

do
	cd /data/aisDn/$i && /bin/bash /data/shellscripts/tar.sh >> /dev/null 2&1
done
