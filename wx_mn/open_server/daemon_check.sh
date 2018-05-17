#!/bin/sh

#set -x
ulimit -n 8192
ulimit -c unlimited

if [ $# -lt 1 ]; then
    echo "daemon_check.sh check"
    exit
fi

ACT=$1
ACT_PARAM=$2

EXEC_PATH=${HOME}

mkdir -p ${EXEC_PATH}/logs/
DATE=`date +%Y%m%d_%H%M%S`

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/"

send_mail_to_office() {
    BIN_NAME=$1
    FILE_PATH=${HOME}/${USER}_${BIN_NAME}_${DATE}.txt
    TEXT="SUBJECT: ${BIN_NAME}\nFROM: liuweiqiao@freeg.cn\nTO: liuweiqiao@freeg.cn,houjunjie@freeg.cn,xiexiaoyong@freeg.cn\nCC: bishaohua@freeg.cn\nMIME-VERSION: 1.0\nContent-type: text/plain\nHi,${BIN_NAME} restart"
    echo -ne $TEXT > ${FILE_PATH}
    /usr/sbin/sendmail -t liuweiqiao@freeg.cn < $FILE_PATH
}

check_process() {
    BIN_NAME=$1
    if [[ "x$BIN_NAME" = "x" ]]; then
        echo ".......... Must in bin name .........."
        exit	
    fi

    sleep 1
    Pid=`ps x | grep ${BIN_NAME} | grep -v grep | grep -v sh | awk '{print $1}'`
    if [[ "x$Pid" = "x" ]]; then
        echo ".......... ${BIN_NAME} is stop .........."
        LOG_FILE=$(echo ${BIN_NAME} | tr '[A-Z]' '[a-z]')
        cd $EXEC_PATH/bin/${BIN_NAME}/
        send_mail_to_office ${BIN_NAME}
        (./${BIN_NAME} &> ${EXEC_PATH}/logs/${LOG_FILE}.log&)
        echo ".......... ${BIN_NAME} restart .........."
    else
        echo ".......... ERROR: ${BIN_NAME} is run .........."
    fi
}

check_alla() {
    check_process LS
    check_process AS
    check_process GS
    check_process BS
}

check_allb() {
    check_process SCS
    check_process DBA
}

check_allt() {
    check_process LS
    check_process AS
    check_process GS
    check_process BS
    check_process DBA
}

case ${ACT} in
    alla ) check_alla ;;
    allb ) check_allb ;;
    allt ) check_allt ;;
    * ) echo "ERROR: [check]." ;;
esac
