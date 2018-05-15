#!/bin/bash
#


if [ -f confinit.sh ]; then
	source confinit.sh
    #echo $servertype
else
    echo "There is no configuration file"
    exit 
fi



cat > /home/${userid}/tools/dump_role_to_web.py <<end
#!/usr/bin/env python

import os
import json
import urllib
import ctypes
import time
import datetime

import database

gamedb_name = "game_${dbsuffix}"
gamedb_host = "127.0.0.1:3306"


webdb_name = "gm"
webdb_host = "10.10.38.18:3306"


def load_from_game_db():
    # today zero time
    today = datetime.date.today()
    # lost day zero time
    curr_time = time.time()
    lost_time = curr_time - 60

    sql_query = "SELECT a.pf_id, a.pf_account,a.area, r.id, r.\`name\`, r.\`level\`, r.vip_level, r.icon_id\
        FROM account as a INNER JOIN player as r on a.id = r.account where a.pf_id > 0 AND r.onlinetime > %d AND r.onlinetime < %d" % (lost_time, curr_time)

    print(sql_query)
    db = database.Connection(gamedb_host, gamedb_name, 'root', '123456')
    list = db.query(sql_query)
    # print("game db query over, lenth=", len(list))
    # over close db
    db.close()
    return list


def update_to_web_db(list):
    sql_format = "INSERT INTO gm_server_rinfo (user_id,user_name,area_id,role_id,role_name,role_level,vip_level,icon_id)\
                  VALUES (%d,'%s',%d,%d,'%s',%d,%d,%d) ON DUPLICATE KEY UPDATE role_id=%d,role_name='%s',role_level=%d,vip_level=%d,icon_id=%d;"

    db = database.Connection(webdb_host, webdb_name, 'root', 'qingluan@123')
    for v in list:
        sql_query = sql_format % (v['pf_id'],v['pf_account'],v['area'],v['id'],v['name'],v['level'],v['vip_level'],v['icon_id'],v['id'],v['name'],v['level'],v['vip_level'],v['icon_id'])
        #print(sql_query)
        lastid = db.execute(sql_query)
    # over to close db
    db.close()

if __name__ == '__main__':
    list = load_from_game_db()
    update_to_web_db(list)
end


cat > /home/${userid}/tools/up_file_to_ftp.py <<end
#!/usr/bin/env python
#-*-coding:utf-8-*-

import os

import time
import random
import urllib
import urllib2
import hashlib
import platform

import json
import ctypes
import datetime

import shutil
import ftplib
import string

def upload_file(filepath, filename):
    ftp = ftplib.FTP()
    ftp.set_debuglevel(2)
    ftp.connect("v5gossfile.v5game.cn", 21)
    print("__________ ftp.connect __________")
    ftp.login("wxftpmnqy", "2beb8a719a7c7365")
    print("__________ ftp.login __________")
    fp = open(filepath + filename,'rb')
    ftp.storbinary('STOR ' + filename, fp, 1024)
    print("__________ ftp.storbinary __________")
    ftp.set_debuglevel(0)
    fp.close()
    ftp.quit()
#def

def v5_http_attack(filepath, filename):
    # filename = "ACCOUNT_2016-03-23_1340.log"
    # nPos = filename.find("_")
    name_list = filename.split('_')
    if 3 != len(name_list):
        return "8888"
    #
    logType = name_list[ 0 ]
    dataDate = name_list[ 1 ]#time.strftime('%Y-%m-%d') #filename[ nPos + 1 : -4]

    body = {
        "logType" : logType,
        "dataDate" : dataDate,
        "fileName" : filename,    
    }

    str_index = "%04d" % random.randint(1, 9999)
    body_text = json.dumps(body)
    transTime = time.strftime("%Y%m%d%H%M%S") #"20160323142005"
    
    microsecond = str( datetime.datetime.now().microsecond )
    messageId = transTime + microsecond[0:3] + str_index

    md5_text = "20006#c19114a051c93a6380e20297895da9a9#" + transTime +"#"+ body_text
    md5 = hashlib.md5()
    md5.update(md5_text)
    md5_digest = md5.hexdigest()
    
    http_attack = {
        "appId" : "20006",
        "body" : body_text,
        "transType" : "LOGFILE",
        "digest" : md5_digest,
        "transTime" : transTime,
        "messageId" : messageId,
    }

    mtext = json.dumps(http_attack)
    print( "Request: %s" % mtext )
    business_url = "http://v5goss.v5game.cn/game/data_service/process"
    request = urllib2.Request(url = business_url, data = mtext)
    request.add_header('Content-Type', 'application/json')
    response = urllib2.urlopen(request)
    result = response.read()
    # SUCCESS, Delete File
    mJson = json.loads(result)
    result_code = mJson["code"]
    return result_code
#def

if "Windows" == platform.system():
    ROOT_PATH = "e:/mblocks/"
elif "Linux" == platform.system():
    ROOT_PATH = "/home/${userid}/"
else:
    print("ERROR: platform system")
    sys.exit()
# not modify this path
ANALYSIS_PATH = "/data/analysis_02/"
LS_PATH = ROOT_PATH + "/bin/LS/log/analysis/"
GS_PATH = ROOT_PATH + "/bin/GS/log/analysis/"

def filter_log_file(file_path, name, dataDate):
    file_list = []
    filename_list = os.listdir(file_path) 
    for infile_name in filename_list:
        # infile_name = "ACCOUNT_2016-03-23_1340.log"
        name_list = infile_name.split('.')
        subfix    = name_list[-1]
        if "log" != subfix:
            continue
        #
        filename  = name_list[0]
        nPos = filename.find('_')
        if -1 == nPos:
            continue
        #
        file_name  = filename[0 : nPos]
        file_Date  = filename[nPos + 1:]
        if name != file_name: 
            continue
        elif dataDate == file_Date:
            continue
        #
        file_list.append(infile_name)
        #
    #
    return file_list
#def
def commit_date_log_file(filepath, name, dataDate):
    file_list = filter_log_file(filepath, name, dataDate)
    for infile_name in file_list:
        # print(infile_name)
        upload_file(filepath, infile_name)
        result_code = v5_http_attack(filepath, infile_name)
        if result_code == "0000" or result_code == "1006":
            print("__________ [%s] __________" % infile_name)
            shutil.move(filepath + infile_name, ANALYSIS_PATH)
        else:
            print("WARN: v5_http_attack code = %s" % result_code)
        #if
    #for
#def 
if __name__ == '__main__':
    if not os.path.exists(ANALYSIS_PATH):
        os.makedirs(ANALYSIS_PATH)
    #if
    timestamp = time.time()
    random.seed(timestamp)
    t_time = int(timestamp / 600) * 600 
    dataDate = time.strftime("%Y-%m-%d_%H%M", time.localtime(t_time))
    print("Date: %s" % dataDate)

    # 1. ACCOUNT
    commit_date_log_file(LS_PATH, 'ACCOUNT', dataDate)
    # 2. PLAYER
    commit_date_log_file(GS_PATH, 'PLAYER',  dataDate)
    # 3. LOGIN
    commit_date_log_file(GS_PATH, 'LOGIN',   dataDate)
    # 4. OTHER
    commit_date_log_file(GS_PATH, 'ORDER',   dataDate)
    commit_date_log_file(GS_PATH, 'COINLOG', dataDate)
    print("__________ OVER __________")
#if
end



cat > /home/${userid}/backup/common_config.lua  <<end
-------------------------------------------------------------------------------------------------------------
-- Project: MobileGame
-- Modle  : common
-- Title  : 运维控制配置表
-- Author : robencle
-------------------------------------------------------------------------------------------------------------
-- History:
--          2014.11.05----Create
-------------------------------------------------------------------------------------------------------------
module "common.common_config"
-------------------------------------------------------------------------------------------------------------
game_db_ip		= "127.0.0.1"    	-- 游戏数据库的IP
game_db_port		= 3306             	-- 游戏数据库的端口
game_db_name		= "game_${dbsuffix}"			-- 游戏数据库的名称
game_db_cs		= "UTF-8"			-- 游戏数据库字符集
-------------------------------------------------------------------------------------------------------------
log_db_ip		= "127.0.0.1"    	-- 日志数据库的IP
log_db_port		= 3306              -- 日志数据库的端口
log_db_name		= "game_${dbsuffix}_log"	    -- 日志数据库的名称
log_db_cs		= "UTF-8"			-- 日志数据库字符集
-------------------------------------------------------------------------------------------------------------
dba_ip			= "${gamedblocalip}"     -- DBA服务器的IP
dba_listen_port		= ${portid}9011     			-- DBA服务器的服务端口
dba_telnet_port		= ${portid}9911          	-- DBA服务器的telnet端口
-------------------------------------------------------------------------------------------------------------
dbu_ip			= "127.0.0.1"       -- DBU服务器的IP
dbu_listen_port		= ${portid}9014          	-- DBU服务器的服务端口
dbu_telnet_port		= ${portid}9914          	-- DBU服务器的telnet端口
-------------------------------------------------------------------------------------------------------------
scs_ip			= "${gamedblocalip}"    -- SCS服务器的IP
scs_listen_port		= ${portid}9999         	    -- SCS服务器的服务端口
scs_telnet_port		= ${portid}9019          	-- SCS服务器的telnet端口
-------------------------------------------------------------------------------------------------------------
ls_ip_for_client	= "0.0.0.0"       	-- LS服务器为Client提供的IP
ls_port_for_client	= ${portid}9016              -- LS服务器为Client提供的服务端口
ls_ip_for_gs		= "127.0.0.1"       -- LS服务器为GS提供的IP
ls_port_for_gs		= ${portid}9015              -- LS服务器为GS提供的服务端口
ls_ip_for_telnet	= "0.0.0.0"    -- LS服务器为Telnet提供的IP
ls_port_for_telnet	= ${portid}9915              -- LS服务器为Telnet提供的服务端口
-------------------------------------------------------------------------------------------------------------
gs_ip			= "${gamelocalip}"    -- GS服务器的IP
gs_listen_port		= ${portid}9020          	-- GS服务器的服务端口
gs_telnet_ip 		= "${gamelocalip}"
gs_telnet_port		= ${portid}9920          	-- GS服务器的telnet端口
gs_http_ip		= "0.0.0.0"	-- GS服务器的http监听IP
gs_http_port		= ${portid}8080				-- GS服务器的http监听端口
-------------------------------------------------------------------------------------------------------------
bs_ip			= "0.0.0.0"			-- BS服务器的IP
bs_domain		= "${gameoutsideip}"   -- BS服务器的域名/IP
bs_listen_port		= ${portid}9030				-- BS服务器的服务端口
bs_telnet_port		= ${portid}9930        		-- BS服务器的telnet端口
-------------------------------------------------------------------------------------------------------------
as_ip			= "${gamelocalip}"    -- AS服务器的IP
as_listen_port		= ${portid}9040         		-- AS服务器的服务端口
as_telnet_port		= ${portid}9940          	-- AS服务器的telnet端口
-------------------------------------------------------------------------------------------------------------
http_host		= '$httpoutsideip'   	-- http ip
http_port		= 8880              -- http port
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
current_area_id		= $currentareaid         		-- 当前区号
current_area_type	= $currentareatype         		-- 当前类型 0:混服 1:安卓 2:IOS越狱 3:IOS正版
------current_version		= $currentversion         		-- 登录版本号
ios_review_version	= $iosreviewversion			-- 是否iOS送审版本 0:非送审版本 1:送审版本 
tx_online_version   = 0                 -- TX 应用宝版本   0:非应用版本, 1:应用宝，天拓
v5_online_version   = 1                 -- V5数据提交标识  0:不提交到 V5, 1:要提交到 V5
v5_appId            = "20006"           -- V5 ID   国内正式 = "20006", 应用宝 = "20008"
-------------------------------------------------------------------------------------------------------------
-- 该配置文件由运维同事进行维护，运维需要将每个区的此份文件备份到对应的区，在服务器关机维护时进行替换
-------------------------------------------------------------------------------------------------------------
----current_version               = 5
--current_version               = 6
current_version               = 7
end



cat > /home/${userid}/backup/config.as  <<end
[GLOBAL]
local_config = 0
custom_name = AssistServer
cmd_title = AS
domain  = scs.game.qingluan
port = ${portid}9999
end



cat > /home/${userid}/backup/config.bs <<end
[GLOBAL]
local_config = 0
custom_name = BridgeServer
cmd_title = BS
domain  = scs.game.qingluan
port = ${portid}9999
end



cat > /home/${userid}/backup/config.dba <<end
[GLOBAL]
local_config = 0
custom_name = DbAgent
cmd_title = DBA
domain  = scs.game.qingluan
port = ${portid}9999
end




cat > /home/${userid}/backup/config.dbu  <<end

[GLOBAL]
local_config = 1
custom_name = DbUpdate
cmd_title = DBU
domain  = scs.game.qingluan
port = ${portid}9999
end



cat > /home/${userid}/backup/config.gs  <<end
[GLOBAL]
local_config = 0
custom_name = GameServer
cmd_title = GS
domain  = scs.game.qingluan
port = ${portid}9999
end



cat > /home/${userid}/backup/config.ls  <<end
[GLOBAL]
local_config = 0
custom_name = LoginServer
cmd_title = LS
domain  = scs.game.qingluan
port = ${portid}9999
end



cat > /home/${userid}/backup/config.scs  <<end
[GLOBAL]
local_config = 1
custom_name = ServiceConfigServer
cmd_title = SCS
domain  = scs.game.qingluan
port = ${portid}9999
end



cd /home/${userid} && rm -rf a_mix*
rm -rf bin/*
cd packet && ls|grep -v *.zip|xargs rm -rf
cd /home && chown -R ${userid}:${userid} ${userid}
