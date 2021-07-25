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
echo "`date`      MQTT Poweroff listener started" >> $log

# load configuration file
source $config
echo "`date`      Configuration loaded" >> $log

hostname=$(cat /etc/hostname)
topic=$(echo "computers/$hostname")

msg=$(mosquitto_sub -h $host -p $port -u $username -P $password -C 1 -t "$topic")
while [ "$msg" != "poweroff" ]
do
	msg=$(mosquitto_sub -h $host -p $port -u $username -P $password -C 1 -t "$topic")
done

echo "`date`      Start poweroff window script" >> $log
$(dirname "$0")/SC_poweroff.sh

echo "shutdown"

# TODO continue loop if poweroff aborted
