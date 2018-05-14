#!/bin/bash
### just for me 
### used to quick login 
### need: echo "alias wssh=/data/shellscripts/J/wssh.sh" >> /etc/profie && source /etc/profile


### together: echo "export GREP_OPTIONS=--color=auto" >> /etc/profile && source /etc/profile


case $1 in
## game server ##
  g1)
	ssh 10.
	;;
	g2)
	ssh 10.
	;;
	g3)
	ssh 10.
	;;
	g4)
	ssh 10.
	;;
	g5)
	ssh 10.
	;;
	g6)
	ssh 10.
	;;
	g7)
	ssh 10.
	;;
	g8)
	ssh 10.
	;;
	g9)
	ssh 10.
	;;

## db server ##	
	d1)
	ssh 10.
	;;
	d2)
	ssh 10.
	;;
	d3)
	ssh 10.
	;;
	d4)
	ssh 10.
	;;
	d5)
	ssh 10.
	;;
	d6)
	ssh 10.
	;;
	d7)
	ssh 10.
	;;
	d8)
	ssh 10.
	;;
	d9)
	ssh 10.
	;;

## db slave ##
	s1)
	ssh 10.
	;;

## php server ##
	php)
	ssh 10.
	;;

## account server ##
	db)
	ssh 10.13.172.120
	;;

## error input ##
	*)
	echo "wrong !"
	;;

esac
