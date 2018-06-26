#!/bin/bash

IP=$1
ping $IP -c 1 |awk '/avg/{print $4}'|awk -F "/" '{print $2}'
