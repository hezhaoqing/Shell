
#!/bin/bash

srcdir=/home/app02/eplbks-frontend-app
destdir=10.0.2.12:/home/app02/

inotifywait -mrq --timefmt '%d/%m/%y-%H:%M' --format '%T %w%f' -e modify,delete,create,attrib ${srcdir} \
| while read file
do
  rsync -arztog --delete ${srcdir} ${destdir}
done

