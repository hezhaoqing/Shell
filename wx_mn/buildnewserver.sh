[root@10-13-144-49 home]# jaydb 305 339 1 3




[root@10-13-144-49 home]# ll /usr/bin/jaydb 
lrwxrwxrwx 1 root root 24 Aug  1  2018 /usr/bin/jaydb -> /data/shellscripts/db.sh




[root@10-13-144-49 home]# cat /data/shellscripts/db.sh 
#!/bin/bash
if [ $# -ne 4 ];then
        echo "ERROR: four args are needed."
        exit 1
elif [[ $3 -gt 5 || $4 -gt 5 ]];then
        echo "ERROR: port error."
        exit 1
fi

read -p "You input $1 $2 $3 $4 , [yes/no ?] :" ANSWER

if [ $ANSWER != "yes" ];then
        echo "Determine your input"
        exit 1

elif [ `netstat -lntp |grep ${4}9999 |wc -l` != 0 ];then
        echo "The port ${4}9999 exist."
        exit 1

elif [ `grep ${3}9999 /home/a_mix_$1/backup/config.gs |wc -l` != 1 ];then
        echo "The port is not exist."
        exit 1

fi

id a_mix_$2

if [ $? == 0 ];then
        echo "The user a_mix_$2 exist."
        exit 1
fi

new1=$(echo $1| sed "s/0//")
new2=$(echo $2| sed "s/0//")

cat > /opt/${1}_${2}_${3}_${4}.sh <<Jay
#!/bin/bash
### used for db ###
useradd a_mix_$2
cd /home && cp -r a_mix_$1/* a_mix_$2
sed -i 's/game_mix_$1/game_mix_$2/g' /home/a_mix_$2/backup/common_config.lua
sed -i '/.*port.*= ${3}.*/s/= $3/= $4/g' /home/a_mix_$2/backup/common_config.lua
sed -i '/current_area_id.*= ${1}.*/s/= $1/= $2/g' /home/a_mix_$2/backup/common_config.lua
if [[ 10#$1 -lt 10 && 10#$2 -ge 10 ]];then
        sed -i '/current_area_id.*= ${new1}.*/s/= ${new1}/= $2/g' /home/a_mix_$2/backup/common_config.lua
elif [[ 10#$1 -lt 10 && 10#$2 -lt 10 ]];then
        sed -i '/current_area_id.*= ${new1}.*/s/= ${new1}/= ${new2}/g' /home/a_mix_$2/backup/common_config.lua
fi
sed -i 's/${3}9999/${4}9999/' /home/a_mix_$2/backup/config.*
#############################################################################
if [ $3 -eq 3 ];then
        sed -i '/.*port.*= ${4}306.*/s/= $4/= 3/g' /home/a_mix_$2/backup/common_config.lua
fi
#############################################################################
cd /home/a_mix_$2/bin && rm -fr ./*
cd /home/a_mix_$2/packet
ls /home/a_mix_$2/packet|grep -v "HuiHe_Game" |xargs rm -fr
#############################################################################
sed -i 's/a_mix_$1/a_mix_$2/' /home/a_mix_$2/tools/up_file_to_ftp.py
sed -i 's/game_mix_$1/game_mix_$2/' /home/a_mix_$2/tools/dump_role_to_web.py
sed -i 's/game_mix_$1/game_mix_$2/' /home/a_mix_$2/tools/backup_db_to_web.py
#############################################################################
chown -R a_mix_$2:a_mix_$2 /home/a_mix_$2
su - a_mix_$2 -c 'cd /home/a_mix_$2;bash update.sh'
sleep 1
su - a_mix_$2 -c 'cd /home/a_mix_$2;bash do.sh start SCS'
su - a_mix_$2 -c 'cd /home/a_mix_$2;bash do.sh start DBU'
sleep 12
cat /home/a_mix_$2/logs/dbu.log |grep "db temp update finished" || exit 1
su - a_mix_$2 -c 'cd /home/a_mix_$2;bash do.sh kill SCS'
su - a_mix_$2 -c 'cd /home/a_mix_$2;bash do.sh kill DBU'
sleep 1
su - a_mix_$2 -c 'cd /home/a_mix_$2;bash do.sh allb'
grep ${4}9 /home/a_mix_$2/backup/ -r
grep $2 /home/a_mix_$2/tools/ -r
sleep 5
cat /home/a_mix_$2/logs/dba.log |grep "DbAgent STARTUP COMPLETED" || echo "DBA start failed."
Jay

sleep 1

if [ -f /opt/${1}_${2}_${3}_${4}.sh ];then
        bash /opt/${1}_${2}_${3}_${4}.sh
else
        exit 1
fi




[root@10-13-144-49 home]# cat /opt/305_339_1_3.sh 
#!/bin/bash
### used for db ###
useradd a_mix_339
cd /home && cp -r a_mix_305/* a_mix_339
sed -i 's/game_mix_305/game_mix_339/g' /home/a_mix_339/backup/common_config.lua
sed -i '/.*port.*= 1.*/s/= 1/= 3/g' /home/a_mix_339/backup/common_config.lua
sed -i '/current_area_id.*= 305.*/s/= 305/= 339/g' /home/a_mix_339/backup/common_config.lua
if [[ 10#305 -lt 10 && 10#339 -ge 10 ]];then
        sed -i '/current_area_id.*= 35.*/s/= 35/= 339/g' /home/a_mix_339/backup/common_config.lua
elif [[ 10#305 -lt 10 && 10#339 -lt 10 ]];then
        sed -i '/current_area_id.*= 35.*/s/= 35/= 339/g' /home/a_mix_339/backup/common_config.lua
fi
sed -i 's/19999/39999/' /home/a_mix_339/backup/config.*
#############################################################################
if [ 1 -eq 3 ];then
        sed -i '/.*port.*= 3306.*/s/= 3/= 3/g' /home/a_mix_339/backup/common_config.lua
fi
#############################################################################
cd /home/a_mix_339/bin && rm -fr ./*
cd /home/a_mix_339/packet
ls /home/a_mix_339/packet|grep -v "HuiHe_Game" |xargs rm -fr
#############################################################################
sed -i 's/a_mix_305/a_mix_339/' /home/a_mix_339/tools/up_file_to_ftp.py
sed -i 's/game_mix_305/game_mix_339/' /home/a_mix_339/tools/dump_role_to_web.py
sed -i 's/game_mix_305/game_mix_339/' /home/a_mix_339/tools/backup_db_to_web.py
#############################################################################
chown -R a_mix_339:a_mix_339 /home/a_mix_339
su - a_mix_339 -c 'cd /home/a_mix_339;bash update.sh'
sleep 1
su - a_mix_339 -c 'cd /home/a_mix_339;bash do.sh start SCS'
su - a_mix_339 -c 'cd /home/a_mix_339;bash do.sh start DBU'
sleep 12
cat /home/a_mix_339/logs/dbu.log |grep "db temp update finished" || exit 1
su - a_mix_339 -c 'cd /home/a_mix_339;bash do.sh kill SCS'
su - a_mix_339 -c 'cd /home/a_mix_339;bash do.sh kill DBU'
sleep 1
su - a_mix_339 -c 'cd /home/a_mix_339;bash do.sh allb'
grep 39 /home/a_mix_339/backup/ -r
grep 339 /home/a_mix_339/tools/ -r
sleep 5
cat /home/a_mix_339/logs/dba.log |grep "DbAgent STARTUP COMPLETED" || echo "DBA start failed."





[root@10-13-144-49 home]# cat a_mix_339/update.sh 
#!/bin/sh

cd $HOME/packet/
unzip -o *.zip
chmod +x copy_bin.sh
./copy_bin.sh
cd $HOME
./copy_ini.sh
#./do.sh stop
#./do.sh all





[root@10-13-144-49 home]# ll a_mix_339/packet/
total 94448
drwxrwxr-x 13 a_mix_339 a_mix_339     4096 May  9 14:32 bin
-rwxrwxr-x  1 a_mix_339 a_mix_339 18633851 May  7 17:30 BS
-rwxrwxr-x  1 a_mix_339 a_mix_339     4611 May  7 17:30 common_config.lua
-rwxrwxr-x  1 a_mix_339 a_mix_339      879 May  7 17:30 copy_bin.sh
-rwxrwxr-x  1 a_mix_339 a_mix_339      460 May  7 17:30 copy_ini.sh
-rwxrwxr-x  1 a_mix_339 a_mix_339 29562890 May  7 17:30 CS
-rwxrwxr-x  1 a_mix_339 a_mix_339     2253 May  7 17:30 daemon_check.sh
-rwxrwxr-x  1 a_mix_339 a_mix_339     3470 May  7 17:30 do.sh
-rwxr-xr-x  1 a_mix_339 a_mix_339 48478491 May  9 14:32 HuiHe_Game_Server_For_Linux_GameFateGD_7516_193_artifacts.zip
-rwxrwxr-x  1 a_mix_339 a_mix_339      455 May  7 17:30 ini_back.sh





[root@10-13-144-49 home]# cat a_mix_339/packet/copy_bin.sh 
#!/bin/sh
set -x
chmod +x *
cp -f BS ./bin/BS/BS
cp -f CS ./bin/LS/LS
cp -f CS ./bin/GS/GS
cp -f CS ./bin/AS/AS
cp -f CS ./bin/SCS/SCS
cp -f CS ./bin/DBA/DBA
cp -f CS ./bin/DBU/DBU
cp -f CS ./bin/CS/CS
cp -f CS ./bin/WS/WS
cp -f CS ./bin/MT/MT
chmod +x ./bin/LS/LS
chmod +x ./bin/LS/run_ls.sh
chmod +x ./bin/BS/BS
chmod +x ./bin/BS/run_bs.sh
chmod +x ./bin/GS/GS
chmod +x ./bin/GS/run_gs.sh
chmod +x ./bin/AS/AS
chmod +x ./bin/AS/run_as.sh
chmod +x ./bin/SCS/SCS
chmod +x ./bin/SCS/run_scs.sh
chmod +x ./bin/DBA/DBA
chmod +x ./bin/DBA/run_dba.sh
chmod +x ./bin/DBU/DBU
chmod +x ./bin/DBU/run_dbu.sh
chmod +x ./bin/CS/CS
chmod +x ./bin/CS/run_cs.sh
chmod +x ./bin/WS/WS
chmod +x ./bin/WS/run_ws.sh
chmod +x ./bin/MT/MT
chmod +x ./bin/MT/run_mt.sh
cp -rf bin $HOME/
if [ -f $HOME/backup/common_config.lua ]; then
        cp -f $HOME/backup/common_config.lua $HOME/bin/lua/common/
fi





[root@10-13-144-49 home]# ll a_mix_339/backup/
total 44
-rwxr-xr-x 1 a_mix_339 a_mix_339 4673 May  9 14:32 common_config.lua
-rwxr-xr-x 1 a_mix_339 a_mix_339  117 May  9 14:32 config.as
-rwxr-xr-x 1 a_mix_339 a_mix_339  117 May  9 14:32 config.bs
-rwxr-xr-x 1 a_mix_339 a_mix_339  113 May  9 14:32 config.dba
-rwxr-xr-x 1 a_mix_339 a_mix_339  114 May  9 14:32 config.dbu
-rwxr-xr-x 1 a_mix_339 a_mix_339  115 May  9 14:32 config.gs
-rwxr-xr-x 1 a_mix_339 a_mix_339  116 May  9 14:32 config.ls
-rwxr-xr-x 1 a_mix_339 a_mix_339  125 May  9 14:32 config.scs
-rwxr-xr-x 1 a_mix_339 a_mix_339 1714 May  9 14:32 dba_fixed_config.lua
-rw-r--r-- 1 a_mix_339 a_mix_339 2648 May  9 14:32 dbu_fixed_config.lua






[root@10-13-144-49 home]# ll a_mix_339/
total 60
drwxr-xr-x  2 a_mix_339 a_mix_339  4096 May  9 14:32 backup
drwxrwxr-x 13 a_mix_339 a_mix_339  4096 May  9 14:32 bin
-rwxr-xr-x  1 a_mix_339 a_mix_339   711 May  9 14:32 copy_ini.sh
-rwxr-xr-x  1 a_mix_339 a_mix_339  2253 May  9 14:32 daemon_check.sh
-rwxr-xr-x  1 a_mix_339 a_mix_339  3633 May  9 14:32 do.sh
drwxr-xr-x  2 a_mix_339 a_mix_339  4096 May  9 14:32 logs
drwxr-xr-x  3 a_mix_339 a_mix_339  4096 May  9 14:32 packet
drwxr-xr-x  4 a_mix_339 a_mix_339  4096 May  9 14:32 tmp
-rwxr-xr-x  1 a_mix_339 a_mix_339 11776 May  9 14:32 tmpdbgd.tar.gz
drwxr-xr-x  2 a_mix_339 a_mix_339  4096 May  9 14:33 tools
-rwxr-xr-x  1 a_mix_339 a_mix_339   129 May  9 14:32 update.sh





[root@10-13-144-49 home]# cat a_mix_339/copy_ini.sh 
#!/bin/sh
set -x
cp -f $HOME/backup/config.as  $HOME/bin/AS/config.ini
cp -f $HOME/backup/config.bs  $HOME/bin/BS/config.ini
cp -f $HOME/backup/config.dba $HOME/bin/DBA/config.ini
cp -f $HOME/backup/config.dbu $HOME/bin/DBU/config.ini
cp -f $HOME/backup/config.ls  $HOME/bin/LS/config.ini
cp -f $HOME/backup/config.gs  $HOME/bin/GS/config.ini
cp -f $HOME/backup/config.scs $HOME/bin/SCS/config.ini
cp -f $HOME/backup/common_config.lua $HOME/bin/lua/common/
cp -f $HOME/backup/dba_fixed_config.lua $HOME/bin/SCS/lua/config
cp -f $HOME/backup/dbu_fixed_config.lua $HOME/bin/SCS/lua/config
cp -f $HOME/backup/dba_fixed_config.lua $HOME/bin/DBA/lua/
cp -f $HOME/backup/dbu_fixed_config.lua $HOME/bin/DBU/lua/





[root@10-13-144-49 a_mix_339]# cat do.sh 
#!/bin/sh

#set -x
ulimit -n 8192
ulimit -c unlimited

if [ $# -lt 1 ]; then
    echo "do.sh start GS | do.sh all | do.sh stop"
    exit
fi

ACT=$1
ACT_PARAM=$2

EXEC_PATH=${HOME}

mkdir -p ${EXEC_PATH}/logs/
Date=`date +%Y%m%d_%H%M%S`

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/"

kill_process() {
    BIN_NAME=$1
    if [[ "x$BIN_NAME" = "x" ]]; then
        echo ".......... Must in bin name .........."
        exit
    fi

    sleep 1 
    Pid=`ps x | grep ${BIN_NAME} | grep -v grep | grep -v sh | awk '{print $1}'`
    if [[ "x$Pid" = "x" ]]; then
        echo "ERROR: ${BIN_NAME} not find."
    else 
        /bin/kill -TERM $Pid

        sleep 1 
        Pid_check=`ps x | grep ${BIN_NAME} | grep -v grep | grep -v sh | awk '{print $1}'`
        if [[ "x$Pid_check" = "x" ]]; then
            echo "${BIN_NAME}($Pid) be killed by kill."
        else
            /usr/bin/pkill -9 ${BIN_NAME}
            echo "${BIN_NAME}($Pid) be killed by pkill."
        fi
    fi 
}

start_process() {
    BIN_NAME=$1
    if [[ "x$BIN_NAME" = "x" ]]; then
        echo ".......... Must in bin name .........."
        exit
    fi

    sleep 1
    Pid=`ps x | grep ${BIN_NAME} | grep -v grep | grep -v sh | awk '{print $1}'`
    if [[ "x$Pid" = "x" ]]; then
        LOG_FILE=$(echo ${BIN_NAME} | tr '[A-Z]' '[a-z]')
        cd $EXEC_PATH/bin/${BIN_NAME}/
        (./${BIN_NAME} &> ${EXEC_PATH}/logs/${LOG_FILE}.log&)
        echo ".......... ${BIN_NAME} start .........."
    else
        echo ".......... ERROR: ${BIN_NAME} is run .........."
    fi
}

create_crontab_a() {
    CRONTAB_FILE=$HOME/crontab.${USER}
    crontab -l > $CRONTAB_FILE
    echo "* * * * * /bin/sh ${HOME}/daemon_check.sh alla >/dev/null 2>&1" >> $CRONTAB_FILE
    echo "0 3 * * * /usr/bin/python ${HOME}/tools/up_file_to_ftp.py >/dev/null 2>&1" >> $CRONTAB_FILE
    crontab $CRONTAB_FILE
    rm -f $CRONTAB_FILE
}

create_crontab_b() {
    CRONTAB_FILE=$HOME/crontab.${USER}
    crontab -l > $CRONTAB_FILE
    echo "* * * * * /bin/sh ${HOME}/daemon_check.sh allb >/dev/null 2>&1" >> $CRONTAB_FILE
    echo "* * * * * /usr/bin/python ${HOME}/tools/dump_role_to_web.py >/dev/null 2>&1" >> $CRONTAB_FILE
    echo "30 3 * * * /usr/bin/python ${HOME}/tools/backup_db_to_web.py >/dev/null 2>&1" >> $CRONTAB_FILE
    crontab $CRONTAB_FILE
    rm -f $CRONTAB_FILE
}

create_crontab_t() {
    CRONTAB_FILE=$HOME/crontab.${USER}
    crontab -l > $CRONTAB_FILE
    echo "* * * * * /bin/sh ${HOME}/daemon_check.sh allt >/dev/null 2>&1" >> $CRONTAB_FILE
    echo "0 3 * * * /usr/bin/python ${HOME}/tools/up_file_to_ftp.py >/dev/null 2>&1" >> $CRONTAB_FILE
    echo "* * * * * /usr/bin/python ${HOME}/tools/dump_role_to_web.py >/dev/null 2>&1" >> $CRONTAB_FILE
    echo "30 3 * * * /usr/bin/python ${HOME}/tools/backup_db_to_web.py >/dev/null 2>&1" >> $CRONTAB_FILE
    crontab $CRONTAB_FILE
    rm -f $CRONTAB_FILE
}

destroy_crontab() {
    crontab -r
}

stop() {
    kill_process DBA
    kill_process SCS
}

alla() {
    start_process LS
    start_process AS
    start_process GS
    start_process BS
}

allb() {
    start_process SCS
    start_process DBA
}

allt() {
    start_process LS
    start_process AS
    start_process GS
    start_process BS
    start_process DBA
}

case ${ACT} in
    alla ) 
        alla
        create_crontab_a
    ;;
    allb ) 
        allb
        create_crontab_b
    ;;
    allt )
        allt
        create_crontab_t
    ;;
    stop )
        destroy_crontab
        stop
    ;;
    kill ) kill_process ${ACT_PARAM} ;;
    start ) start_process ${ACT_PARAM} ;;
    * ) echo "IN: [alla | allb | allt | start | stop].";;
esac


