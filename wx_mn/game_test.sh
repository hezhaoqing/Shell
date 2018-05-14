#!/bin/bash

echo "#!/bin/bash
### used for guofu game ###
useradd a_mix_$2
cd /home && cp -r a_mix_$1/* a_mix_$2
sed -i 's/game_mix_$1/game_mix_$2/g' /home/a_mix_$2/backup/common_config.lua
sed -i '/.*port.*= "$3".*/s/= "$3"/= "$4"/g' /home/a_mix_$2/backup/common_config.lua
sed -i '/current_area_id.*= "$1".*/s/= "$1"/= "$2"/g' /home/a_mix_$2/backup/common_config.lua
sed -i 's/"$3"9999/"$4"9999/' /home/a_mix_$2/backup/config.*
grep "$4"9 /home/a_mix_$2/backup/ -r
#############################################################################
if [ $3 -eq 3 ];then
sed -i '/.*port.*= "$4"306.*/s/= "$4"/= 3/g' /home/a_mix_$2/backup/common_config.lua
fi
#############################################################################
cd /home/a_mix_$2/bin && rm -fr ./*
cd /home/a_mix_$2/packet
ls /home/a_mix_$2/packet|grep -v "HuiHe_Game" |xargs rm -fr
#############################################################################
sed -i 's/game_mix_$1/game_mix_$2/' /home/a_mix_$2/tools/backup_db_to_web.py
sed -i 's/a_mix_$1/a_mix_$2/' /home/a_mix_$2/tools/up_file_to_ftp.py
sed -i 's/game_mix_$1/game_mix_$2/' /home/a_mix_$2/tools/dump_role_to_web.py
grep $2 /home/a_mix_$2/tools/ -r
#############################################################################
chown -R a_mix_$2:a_mix_$2 /home/a_mix_$2
su a_mix_$2
cd /home/a_mix_$2
./update.sh
./do.sh alla
sleep 8
cat logs/gs.log
ps x"
