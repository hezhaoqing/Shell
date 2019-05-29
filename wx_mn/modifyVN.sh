#!/bin/bash

mv /var/www/html/resources/hotLink/PlatformVersion.txt /var/www/html/resources/hotLink/PlatformVersion.txt.`date +%F`

cat > /var/www/html/resources/hotLink/PlatformVersion.txt << Jay

[{"platform":"pc","version":"1.0.0","uiVersion":"1.0.0","operationSystem":"android","hotUpdateURL":"http:\/\/192.168.0.15\/resources\/","loginURL":"http:\/\/192.168.0.15"},{"platform":"gdAndroid","version":"1.0.$1","uiVersion":"1.0.$1","operationSystem":"android","hotUpdateURL":"http:\/\/106.75.175.163\/resources\/","loginURL":"http:\/\/103.92.33.59:8880"},{"platform":"dgIOS","version":"1.0.$2","uiVersion":"1.0.$2","operationSystem":"ios","hotUpdateURL":"http:\/\/106.75.175.163\/resources\/","loginURL":"http:\/\/103.92.33.59:8880"}]

Jay
