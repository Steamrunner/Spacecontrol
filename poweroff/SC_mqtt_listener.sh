#!/usr/bin/env bash

# get command line options
config=poweroff.conf
log=poweroff.log

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

hostname=$(cat /etc/hostname)
topic=$(echo "/computers/$hostname")

msg=$(mosquitto_sub -h $host -p $port -u $username -P $password -C 1 -t "$topic")
while [ "$msg" != "poweroff" ]
do
	msg=$(mosquitto_sub -h $host -p $port -u $username -P $password -C 1 -t "$topic")
done

$(dirname "$0")/SC_poweroff.sh

echo "shutdown"

