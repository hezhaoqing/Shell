#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

read -p "please choice a colour :" INPUT

if [ $INPUT == red ];then
	printf $red"red"$neutral"\n"
elif [ $INPUT == green ];then
	printf $green"green"$neutral"\n"
else
	printf "##########\n"
fi
