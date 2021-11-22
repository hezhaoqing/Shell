#!/bin/bash

### 2021-11-18
### just use to install node_exporter in linux-amd64

cd /opt/ 

[ -f node_exporter-1.2.2.linux-amd64.tar.gz ] && tar xzf node_exporter-1.2.2.linux-amd64.tar.gz || echo -e "\033[31mplease prepare the soft\033[0m"


[ -d node_exporter-1.2.2.linux-amd64 ] && chown root:root -R node_exporter-1.2.2.linux-amd64 || exit 1


#### 把node_exporter添加到服务自启动
cat > /usr/lib/systemd/system/node_exporter.service << EOF
[Unit]
Description=node-exporter
After=network.target

[Service]
WorkingDirectory=/opt/node_exporter-1.2.2.linux-amd64/
ExecStart=/opt/node_exporter-1.2.2.linux-amd64/node_exporter --collector.processes --no-collector.softnet --no-collector.arp --no-collector.zfs --no-collector.nfs --no-collector.nfsd --no-collector.ipvs --no-collector.entropy
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF

### 验证9100端口是否已经被占用
netstat -lntp| grep 9100 >> /dev/null 2>&1

if [$? == 0];then

	echo -e "\033[31mPort:9100 has be used\033[31m"
	exit 1
	
else
	systemctl start node_exporter.service

fi

### 验证node_exporter是否已经运行
systemctl status node_exporter.service | grep running  >> /dev/null 2>&1

if [$? == 0];then

	echo -e "\033[32m node_exporter is installed  successfully and started.\033[0m"

else
	echo -e "\033[31m error: node-exporter,please check.\033[0m"
fi
