#!/bin/bash

IP=$1
ping $IP -c 2 |awk '/packets/{print $6}'|awk -F "%" '{print $1}'
