#!/bin/bash
case $3 in

	c)
	cat /dev/null > ./ip.txt
	;;

esac

cat >> ./ip.txt <<jay
10.13.${1}.${2}
jay

cat ./ip.txt
