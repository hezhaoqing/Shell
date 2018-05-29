#!/bin/bash
###  used for the machine of new add
### 
sed -i '/$1/d' /root/.ssh/known_hosts
###

expect << EOF &> /dev/null
spawn scp /root/.ssh/id_rsa.pub $1:/root/.ssh/authorized_keys
expect "no)?"
send "yes\r"
expect "password:"
send "xxxxxxxxx\r"
expect eof
EOF
