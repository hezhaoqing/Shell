#!/bin/bash
cat << EOF
##############################################################
  delete  username  and  cancle  sudo privileges.
##############################################################
EOF
read -p  "Please  input username  which you want to del:" username
userdel  -r $username
sed  -i "/${username}/d" /etc/sudoers

echo "Delete $username finished."
