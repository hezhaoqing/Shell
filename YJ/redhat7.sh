#!/bin/bash
#usage:set redhat7 systctl.conf ulimit install net-tools
adjust_sysctl_value()
{
####内核参数列表，具体数值根据实际情况配置增加或者减少####
sysctl_key[1]=net.ipv4.ip_forward
sysctl_value[1]=0
sysctl_key[2]=net.ipv4.conf.default.rp_filter
sysctl_value[2]=1
sysctl_key[3]=net.ipv4.conf.default.accept_source_route
sysctl_value[3]=0
sysctl_key[4]=kernel.sysrq
sysctl_value[4]=0
sysctl_key[5]=kernel.core_uses_pid
sysctl_value[5]=1
sysctl_key[6]=net.ipv4.tcp_syncookies
sysctl_value[6]=1
sysctl_key[7]=kernel.msgmnb
sysctl_value[7]=65536
sysctl_key[8]=kernel.msgmax
sysctl_value[8]=65536
sysctl_key[9]=kernel.shmmax
sysctl_value[9]=68719476736
sysctl_key[10]=kernel.shmall
sysctl_value[10]=4294967296
sysctl_key[11]=net.ipv4.tcp_max_tw_buckets
sysctl_value[11]=6000
sysctl_key[12]=net.ipv4.tcp_sack
sysctl_value[12]=1
sysctl_key[13]=net.ipv4.tcp_window_scaling
sysctl_value[13]=1
sysctl_key[14]=net.ipv4.tcp_rmem
sysctl_value[14]="4096 87380 4194304"
sysctl_key[15]=net.ipv4.tcp_wmem
sysctl_value[15]="4096 16384 4194304"
sysctl_key[16]=net.core.wmem_default
sysctl_value[16]=8388608
sysctl_key[17]=net.core.rmem_default
sysctl_value[17]=8388608
sysctl_key[18]=net.core.rmem_max 
sysctl_value[18]=16777216
sysctl_key[19]=net.core.wmem_max
sysctl_value[19]=16777216
sysctl_key[20]=net.core.netdev_max_backlog
sysctl_value[20]=262144
sysctl_key[21]=net.core.somaxconn
sysctl_value[21]=65535
sysctl_key[22]=net.ipv4.tcp_max_orphans
sysctl_value[22]=3276800
sysctl_key[23]=net.ipv4.tcp_max_syn_backlog
sysctl_value[23]=262144
sysctl_key[24]=net.ipv4.tcp_synack_retries
sysctl_value[24]=1
sysctl_key[25]=net.ipv4.tcp_syn_retries
sysctl_value[25]=1
sysctl_key[26]=net.ipv4.tcp_mem
sysctl_value[26]="94500000 915000000 927000000"
sysctl_key[27]=net.ipv4.tcp_fin_timeout
sysctl_value[27]=1
sysctl_key[28]=net.ipv4.ip_local_port_range
sysctl_value[28]="1024 65535"
sysctl_key[29]=net.ipv4.tcp_keepalive_time
sysctl_value[29]=90
sysctl_key[30]=net.ipv4.tcp_keepalive_intvl
sysctl_value[30]=15
sysctl_key[31]=net.ipv4.tcp_keepalive_probes
sysctl_value[31]=3
####备份内核参数文件####
cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
########修改内核参数#####
length=${#sysctl_key[@]}
for ((i=1;i<=$length;i++))
do
sysctl_key=${sysctl_key[$i]}
sysctl_value=${sysctl_value[$i]}
cat /etc/sysctl.conf | grep -v ^# | grep -Eq "$sysctl_key" 
if [ $? -ne 0 ];then
	echo "$sysctl_key = $sysctl_value">>/etc/sysctl.conf
	echo "adjust $sysctl_key = $sysctl_value success"
else
	sed -i 's/$sysctl_key.*/$sysctl_key = $sysctl_value/' /etc/sysctl.conf
	echo "adjust $sysctl_key = $sysctl_value success"
fi
done
/sbin/sysctl -p
echo "sysctl set ok!"
}
######设置防火墙#######
adjust_iptables()
{
#停止firewall
systemctl stop firewalld.service
#禁止firewall开机启动
systemctl disable firewalld.service
####安装iptables并启动###
yum -y install iptables-services>/dev/null
systemctl start iptables
systemctl enable iptables
echo "iptables set ok!"
}

####禁用selinux####
disable_selinux()
{
grep -Eiqw "selinux=enforcing" /etc/sysconfig/selinux
if [ $? -eq 0 ];then
	setenforce 0
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
fi	
echo "selinux set ok!"
}	
###安装ifconfig命令net-tools，lsof,lrzsz，wget命令
yum_install_tools()
{
yum -y install net-tools lrzsz lsof wget telnet>/dev/null && echo "net-tools install ok"
}
####配置yum#######
yum_set()
{
if [ ! -f /etc/yum.repo.d/simope_sc_rhel7.1.repo ];then
	wget -P /etc/yum.repo.d ftp://113.105.151.195/simope_sc_rhel7.1.repo
fi
}

#添加ssh防爆破脚本
add_scan_sshd(){
[ -d /root/yunwei/monitor/ ] || mkdir -p /root/yunwei/monitor/
cat > /root/yunwei/monitor/scan_sshd_linux.sh << 'EOF'
#!/bin/bash
cat /var/log/secure /var/log/messages|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /root/black.txt
DEFINE="20"
for i in `cat /root/black.txt`
do
IP=`echo $i |awk -F= '{print $1}'`
NUM=`echo $i|awk -F= '{print $2}'`
if [ $NUM -gt $DEFINE ];
then
grep $IP /etc/hosts.deny > /dev/null
if [ $? -gt 0 ];
then
echo "sshd:$IP" >> /etc/hosts.deny
fi
fi
done
EOF
chmod a+x /root/yunwei/monitor/scan_sshd_linux.sh
grep -q scan_sshd_linux.sh /etc/crontab || echo "*/10 * * * * root  /root/yunwei/monitor/scan_sshd_linux.sh" >> /etc/crontab
/bin/systemctl restart crond.service
/bin/systemctl restart sshd.service
echo -e "add scan_sshd OK!"
}

#####增加系统登录提示信息####
add_login_info()
{
cat > /etc/motd << EOF
######################################################################################################
The company system administrator, illegally logged in, shall be investigated for legal responsibility.
非公司系统管理员，非法登录，追究法律责任。
######################################################################################################
EOF
}
####增加同步时间定时任务#####
add_ntp_cron()
{
rpm -qa|grep "^ntp-" 
if [ $? -ne 0 ] ; then
	 yum install -y ntp && echo "5  *  *  *  *  root  /usr/sbin/ntpdate 113.105.151.195" >> /etc/crontab  || { echo "line $LINENO error!";exit 1; }
else
    grep "/usr/sbin/ntpdate" /etc/crontab || echo "5  *  *  *  *  root  /usr/sbin/ntpdate 113.105.151.195" >> /etc/crontab 
fi
echo -e "setup ntpdate success"
}
####设置ulimit文件数###
handle_ulimit()
{
echo -e "start config system handle"
ulimit -HSn 65536
grep "soft nofile 65536" /etc/security/limits.conf >> ./systeminit.log 2>&1
if [ $? -ne 0 ];then
echo -ne "
* soft nofile 65536
* hard nofile 65536
" >>/etc/security/limits.conf
echo -e "config ulimit handle success"
else
echo -e "system handle is old config"
fi
}

#禁止更改重要文件
lock_file()
{
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/group
chattr +i /etc/gshadow
}
#删除不必要的系统用户和群组
del_user_group()
{
echo -e "start del user and group"
userdel adm  &>/dev/null
userdel lp    &>/dev/null
userdel shutdown  &>/dev/null
userdel halt   &>/dev/null  
#userdel news
userdel uucp  &>/dev/null
userdel operator  &>/dev/null
userdel games  &>/dev/null
userdel gopher  &>/dev/null
groupdel adm  &>/dev/null
groupdel lp  &>/dev/null
#groupdel news
#groupdel uucp
#groupdel games
groupdel dip  &>/dev/null
#groupdel pppusers
echo -e "del user and group success"
}

#setup shell audit ---------------------------------------------
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
#cat >> /etc/profile << EOF
#export HISTORY_FILE=/etc/share/um/um.log
#export PROMPT_COMMAND='{ date "+%y-%m-%d %T ##### '$(who am i |awk "{print \$1\" \"\$2\" #\"\$5}")'  ####'$(id|awk "{print \$1}")' #### '$(history 1 | { read x cmd; echo "$cmd"; #})"'; } >>$HISTORY_FILE'
#EOF
grep "PROMPT_COMMAND" /etc/profile >> ./systeminit.log 2>&1
if [ $? -ne 0 ];then
cat >> /etc/profile << EOF
export HISTORY_FILE=/etc/share/um/um.log
export PROMPT_COMMAND='{ date "+%y-%m-%d %T ##### \$(who am i | awk "{print \\\$1\" \"\\\$2\" \"\\\$5}")  ####\$(id|awk "{print \\\$1}") #### \$(history 1 | { read x cmd; echo "\$cmd"; })"; } >> \\\$HISTORY_FILE'
EOF
sed -i 's#\\\$HISTORY_FILE#\$HISTORY_FILE#g' /etc/profile
source /etc/profile
fi
echo -e "setup shell audit success"
}



main()
{
adjust_sysctl_value || return 1
adjust_iptables || return 1 
disable_selinux || return 1 
yum_install_tools || return 1
#lock_file || return 1
#yum_set
add_scan_sshd
add_login_info
add_ntp_cron
handle_ulimit
del_user_group
shaudit
}
main 
