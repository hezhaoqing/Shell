#!/usr/bin/env python
# -*- coding: utf_8 -*-
import os
import sys
from threading import Thread
import time


#vim /etc/hosts


### 定义这个函数的原因是：  游戏服、db服 在做相同的动作，而 main 函数里的ansibledo 是只在某类服务器执行的操作 ####
def threaddo(hostip, path, userid):
	ansibledo1 = "ansible %s -m shell -a \" useradd %s  \" " % (hostip, userid)

	print ansibledo1
	os.system(ansibledo1)

	ansibledo2 = "ansible %s -m shell -a \" cp -r /home/a_mix_96/* /home/%s  \" " % (hostip, userid)
	print ansibledo2
	os.system(ansibledo2)

	ansibledo3 = "ansible %s -m copy -a \" src=%s dest=/home/%s \" " % (hostip, path, userid)

	print ansibledo3
	os.system(ansibledo3)

	ansibledo5 = "ansible %s -m shell -a \" cd /home/%s; bash configfile.sh \" " % (hostip,userid)

	print ansibledo5
	os.system(ansibledo5)

        ansibledo7 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash update.sh  ' \"     "     % (hostip, userid, userid)
        print ansibledo7
        os.system(ansibledo7)

def main():
	gameserverip = raw_input("gameserverip: ")
	dbserverip = raw_input("dbserverip: ")
	userid = raw_input("userid: ")
 	gamepath = raw_input("gamefilepath: ")
	dbpath = raw_input("dbfilepath: ")

        th1 = Thread(target=threaddo,args=(dbserverip, dbpath, userid))
        th2 = Thread(target=threaddo,args=(gameserverip, gamepath, userid))

        th1.start()
        th2.start()

        th1.join()
        th2.join()


        ansibledo9 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash do.sh start SCS  ' \"     "     % (dbserverip, userid, userid)
        print ansibledo9
        os.system(ansibledo9)

        ansibledo10 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash do.sh start DBU ' \"     "      % (dbserverip, userid, userid)
        print ansibledo10
        os.system(ansibledo10)

        time.sleep(5)

        ansibledo11 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash do.sh kill SCS ' \"     "       % (dbserverip, userid, userid)
        print ansibledo11
        os.system(ansibledo11)

        ansibledo12 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash do.sh kill DBU ' \"     "       % (dbserverip, userid, userid)
        print ansibledo12
        os.system(ansibledo12)

        ansibledo13 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash do.sh allb ' \"     "           % (dbserverip, userid, userid)
        print ansibledo13
        os.system(ansibledo13)

        time.sleep(5)

        ansibledo14 = "ansible %s -m shell -a \" su - %s -c ' cd /home/%s/; bash do.sh alla  ' \"     "          % (gameserverip, userid, userid)
        print ansibledo14
        os.system(ansibledo14)

if __name__=="__main__":
	main()
