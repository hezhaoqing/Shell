**************************
*** ansible management ***
**************************
printf "export GREP_OPTIONS=--color=auto\nalias wssh=/data/shellscripts/J/wssh.sh\n" >> /etc/profile && source /etc/profile




*********************
*** ansible agent ***
*********************
#!/bin/bash
# put into playbook , need : source /etc/profile
grep GREP_OPTIONS=--color=auto /etc/profile
if [ $? != 0 ];then
    echo "export GREP_OPTIONS=--color=auto" >> /etc/profile
fi




**************************
***    my_grep task    ***
**************************
- name: tttttttttttttest
  hosts: 172.23.13.78
  remote_user: sg186
  sudo: yes
  gather_facts: false
  tasks:
  - name: modify
    script: /data/shellscripts/J/my_grep.sh
    notify: 
      - source profile

  handlers:
  - name: source profile
    shell: source /etc/profile




**************************
***      wssh.sh       ***
**************************
#!/bin/bash

case $1 in
	g1)
	ssh -p 18622 sg186@172.23.13.51
	;;
	g2)
	ssh -p 18622 sg186@172.23.13.52
	;;
	g3)
	ssh -p 18622 sg186@172.23.13.72
	;;
	g4)
	ssh -p 18622 sg186@172.23.13.73
	;;
	g5)
	ssh -p 18622 sg186@172.23.13.75
	;;
	g6)
	ssh -p 18622 sg186@172.23.13.76
	;;
	g7)
	ssh -p 18622 sg186@172.23.13.55
	;;
	g8)
	ssh -p 18622 sg186@172.23.13.22
	;;
	g9)
	;;

	
	d1)
	ssh -p 18622 sg186@172.23.13.53
	;;
	d2)
	ssh -p 18622 sg186@172.23.13.54
	;;
	d3)
	ssh -p 18622 sg186@172.23.13.74
	;;
	d4)
	ssh -p 18622 sg186@172.23.13.60
	;;
	d5)
	ssh -p 18622 sg186@172.23.13.78
	;;
	d6)
	ssh -p 18622 sg186@172.23.13.77
	;;
	d7)
	ssh -p 18622 sg186@172.23.13.23
	;;
	d8)
	ssh -p 18622 sg186@172.23.13.21
	;;
	d9)
	;;


	*)
	echo "Wrong !"

esac




**************************
**************************
