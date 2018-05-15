#!/bin/bash
#
#配置文件
portid=4                                 #给端口分配时第一位浮动数字 
gamedblocalip=10.10.199.34                #游戏db内网ip   
gamelocalip=10.10.160.85               #游戏内网ip     
gameoutsideip=106.75.35.189        #游戏外网ip     
userid=a_mix_138                            #增加的用户名
dbsuffix=mix_138	                         #数据库名称后缀，前缀为game
currentareaid=138                        #当前区号  

#servertype=gameserver                    #服务器类型：gameserver or gamedb

httpoutsideip=106.75.6.10                #http外网ip     
webdbip=10.10.38.18						 #PHP数据库内网ip

currentareatype=0                        #当前类型 0:混服 1:安卓 2:IOS越狱 3:IOS正版
currentversion=4                         #登录版本号
iosreviewversion=0                       #是否iOS送审版本 0:非送审版本 1:送审版本 
