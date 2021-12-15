#!/bin/bash
### 按照等保3要求配置，仅新增服务器之后初始化执行一次，不可多次执行。

### 创建系统文件备份目录
mkdir /opt/sysfileback

###
cp /etc/audit/rules.d/audit.rules /opt/sysfileback/

cat >> /etc/audit/rules.d/audit.rules << EOF

### 收集会话启动信息
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k logins
-w /var/log/btmp -p wa -k logins

### 收集登录和注销事件
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins

### 收集修改系统的强制访问控制的事件 
-w /etc/selinux/ -p wa -k MAC-policy
-w /usr/share/selinux/ -p wa -k MAC-policy

### 收集修改用户/组信息的事件
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity

### 确保审核配置是不变的
-e 2

### 收集系统管理员操作（sudolog）
-w /var/log/sudo.log -p wa -k actions

### 系统管理范围（sudoers）更改的收集
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope

EOF

service auditd restart


### 启用对在auditd之前启动的进程的审计
cp /etc/default/grub /opt/sysfileback/

sed -i '/GRUB_CMDLINE_LINUX/s/=.*/="audit=1"/' /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg


### 确保审核日志不会自动删除
cp /etc/audit/auditd.conf /opt/sysfileback/

sed -i '/max_log_file_action/s/= ROTATE/= keep_logs/' /etc/audit/auditd.conf




###
cp /etc/sysctl.conf /opt/sysfileback/

cat >> /etc/sysctl.conf <<EOF

### 启用地址空间布局随机化（ASLR）
kernel.randomize_va_space = 2

### 确保核心转储受到限制
fs.suid_dumpable = 0

EOF

sysctl -p


### 确保核心转储受到限制
cp /etc/security/limits.conf /opt/sysfileback/
cat >> /etc/security/limits.conf <<EOF

* hard core 0

EOF


### 配置bootloader配置的权限
chown root:root /boot/grub2/grub.cfg
chmod og-rwx /boot/grub2/grub.cfg


### 默认用户umask限制为027
cp /etc/profile /opt/sysfileback/
cp /etc/bashrc /opt/sysfileback/

sed -i '/umask/s/0.*/027/g' /etc/profile
sed -i '/umask/s/0.*/027/g' /etc/bashrc

### 确保默认用户shell超时为900秒或更短
echo "TMOUT=900" >> /etc/profile
echo "TMOUT=900" >> /etc/bashrc

###



### 配置密码尝试失败的锁定
cp /etc/pam.d/password-auth /opt/sysfileback/
cp /etc/pam.d/system-auth /opt/sysfileback/

cat >>/etc/pam.d/password-auth << EOF
###***###
auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900
auth [success=1 default=bad] pam_unix.so
auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900

EOF

cat >>/etc/pam.d/system-auth <<EOF
###***###
auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900
auth [success=1 default=bad] pam_unix.so
auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900

EOF

### 配置SSH空闲超时间隔、SSH MaxAuthTries、禁用SSH空密码登录
cp /etc/ssh/sshd_config /opt/sysfileback/

cat >> /etc/ssh/sshd_config <<EOF
###***###
ClientAliveInterval 300
ClientAliveCountMax 0

MaxAuthTries 4 

PermitEmptyPasswords no
 
EOF

echo ""
echo "*****************************"
echo 'txy_server_db3_init complete!'
