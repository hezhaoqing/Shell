#!/bin/bash
###  used for the machine of new add
### 
sed -i '/'$1'/d' /root/.ssh/known_hosts       ### 小坑：sed使用双引号，变量直接引用。
                                                       sed使用单引号，变量必须加单引号，不加或双引号都不行。
###

expect << EOF &> /dev/null
spawn scp /root/.ssh/id_rsa.pub $1:/root/.ssh/authorized_keys
expect "no)?"
send "yes\r"
expect "password:"
send "xxxxxxxxx\r"
expect eof
EOF
