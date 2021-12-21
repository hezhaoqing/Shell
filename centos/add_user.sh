#!/bin/bash

# -------------------
while true;
        do

                read -p "please input username:" user

                if [ x$user == x ];then
                        echo "bad username"
                        continue;
                fi

                read -p "please input passwd:" passwd1
                read -p "please input passwd again:" passwd2

                if [ y$passwd1 == y ];then
                        echo "bad passwd"
                        continue;
                fi


                id $user >> /dev/null 2>&1

                if [ $? -eq 0 ];then
                        echo "User $user is exist."
                        continue;
                fi

                if [ "$passwd1" != "$passwd2" ];then

                        echo "your input is wrong"
                        continue;
                fi
                useradd $user  # &&  sed -i.bak "/^root/a$user   ALL=(ALL)       ALL" /etc/sudoers
                echo "$passwd1" | passwd --stdin $user  &> /dev/null

                echo "User $user create successful!"
                break;

        done


###
test -d /home/$user/.ssh || mkdir -p /home/$user/.ssh

sshpass -p xxxx ssh -o StrictHostKeyChecking=no jenkins@10.0.2.10 'pwd'  >> /dev/null 2>&1
sshpass -p xxxx scp jenkins@10.0.2.10:/home/jenkins/.ssh/id_rsa.pub /home/$user/.ssh/authorized_keys

chown $user:$user -R /home/$user/.ssh






