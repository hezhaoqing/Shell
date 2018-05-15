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
    kill_process LS
    kill_process AS
    kill_process GS
    kill_process BS
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


startmt() {
    start_process MT 
}

stopmt() {
    kill_process MT
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
    startmt )
       startmt 
    ;;
    stopmt )
       stopmt 
    ;; 
    kill ) kill_process ${ACT_PARAM} ;;
    start ) start_process ${ACT_PARAM} ;;
    * ) echo "IN: [alla | allb | allt | start | stop].";;
esac

