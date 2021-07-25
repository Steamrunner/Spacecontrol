#!/usr/bin/env bash

# get command line options
config=wakeup.conf
log=wakeup.log

while getopts c:l:h flag
do
    case "${flag}" in
        c) config=${OPTARG};;
        l) log=${OPTARG};;
        h) 
        	echo "help"
        	exit 0
        	;;
    esac
done

# load configuration file
source $config

# load target hostnames and mac-addresses
source $targethostsfile

while :
do
	recieved=$(mosquitto_sub -h $host -p $port -u $username -P $password -v -C 1 -t "computers/#")

	msg="${recieved/* /}"
		
	if [ "$msg" = "wakeup" ]
	then
		targethost="${recieved/\/computers\//}"
		targethost="${targethost/ */}"
		mac=${!targethost}
		
		if [ "$mac" != "" ]
		then
			echo "wakeup $targethost ${!targethost}"
			wakeonlan ${!targethost}
		fi
	fi
done

