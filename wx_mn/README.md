# Shell


record all shellscripts in the MN project

同一类服务器的移动脚本 和 清理脚本 可以写到一起的，因为刚开始为了不同的定时执行频率选择了分开写，后来用了ansible-playbook 也没合并。

不同类服务器的 移动脚本、清理脚本，除了目录名称其它一致 

游戏服，DB服的开新服脚本game_test.sh 和 db_test.sh 是最初 为了得出 开服的系列命令，所以选择了echo.正式脚本见子目录my_open_server.
