# -*- coding: utf-8 -*-
import os
import json
import requests
import arrow
from flask import Flask
from flask import request
app = Flask(__name__)
ROBOT_TOKEN = "a8***-741a-4500-b232-cc*****c51f"


def bytes2json(data_bytes):
    data = data_bytes.decode('utf8').replace("'", '"')
    return json.loads(data)


def makealertdata(data):
    for output in data['alerts'][:]:
        try:
            message = output['annotations']['message']
        except KeyError:
            try:
                message = output['annotations']['summary']
            except KeyError:
                message = 'null'
        try:
            value = output['annotations']['value']
        except KeyError:
            value = 'null'


        if output['status'] == 'firing':
            status_zh = '报警'
            alertname = output['labels']['alertname']
            title = '%s 触发报警' % (output['labels']['alertname'])

            title = f'😱 <font color=\"warning\">PROBLEM</font>'

            send_data = {
                "msgtype": "markdown",
                "markdown": {
                    "content": "## %s \n\n" % title +
                    ">**告警级别**: %s \n\n" % output['labels']['level'] +
                    ">**告警类型**: %s \n\n" % output['labels']['alertname'] +
                    ">**告警主机**: %s \n\n" % output['labels']['m_node'] +
                    ">**告警详情**: %s \n\n" % message +
                    ">**告警值**: %s \n\n" % value +
                    ">**告警状态**: %s \n\n" % output['status'] +
                    ">**触发时间**: %s \n\n" % arrow.get(output['startsAt']).to('Asia/Shanghai').format(
                        'YYYY-MM-DD HH:mm:ss ZZ')
                }
            }
        elif output['status'] == 'resolved':
            status_zh = '恢复'
            title = '%s 报警恢复' % (output['labels']['alertname'])
            title = f'😅 <font color=\"info\">OK</font>'
            send_data = {
                "msgtype": "markdown",
                "markdown": {
                    "content": "## %s \n\n" % title +
                    ">**告警级别**: %s \n\n" % output['labels']['level'] +
                    ">**告警类型**: %s \n\n" % output['labels']['alertname'] +
                    ">**告警主机**: %s \n\n" % output['labels']['m_node'] +
                    ">**告警详情**: %s \n\n" % message +
                    ">**告警状态**: %s \n\n" % output['status'] +
                    ">**告警值**: %s \n\n" % value +
                    ">**触发时间**: %s \n\n" % arrow.get(output['startsAt']).to('Asia/Shanghai').format(
                        'YYYY-MM-DD HH:mm:ss ZZ') +
                    ">**触发结束时间**: %s \n" % arrow.get(output['endsAt']).to('Asia/Shanghai').format(
                        'YYYY-MM-DD HH:mm:ss ZZ')
                }
            }
        return send_data


def send_alert(data):
    token = ROBOT_TOKEN
    if not token:
        print('you must set ROBOT_TOKEN env')
        return
    url = 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=%s' % token
    send_data = makealertdata(data)
    req = requests.post(url, json=send_data)
    result = req.json()
    if result['errcode'] != 0:
        print('notify dingtalk error: %s' % result['errcode'])


@app.route('/', methods=['POST', 'GET'])
def send():
    if request.method == 'POST':
        post_data = request.get_data()
        send_alert(bytes2json(post_data))
        return 'success'
    else:
        return 'weclome to use prometheus alertmanager dingtalk webhook server!'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
