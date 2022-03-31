shaudit()
{
echo -e "start setup shell audit"
if [ ! -f /etc/share/um/um.log ];then
    mkdir -p /etc/share/um/
    cat /dev/null  >/etc/share/um/um.log
                chown nobody:nobody /etc/share/um/um.log
                chmod 002 /etc/share/um/um.log
                chattr +a /etc/share/um/um.log
fi
grep "PROMPT_COMMAND" /etc/profile >> ./systeminit.log 2>&1
if [ $? -ne 0 ];then
cat >> /etc/profile << EOF
#
export PROMPT_COMMAND='{ date "+%y-%m-%d %T ### \$(who am i | awk "{print \\\$1\" \"\\\$2\" \"\\\$5}")  ### \$(id|awk "{print \\\$1}") ### \$(history 1 | { read x cmd; echo "\$cmd"; })"; } >> /etc/share/um/um.log'
#
EOF
source /etc/profile
fi
echo -e "setup shell audit success"
}
