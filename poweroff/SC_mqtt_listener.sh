#!/usr/bin/env bash

# set defaults
host=localhost
port=1883
config=poweroff.conf
log=poweroff.log

# get command line options
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

# load configuration file if available
source $config 2>/dev/null
configLoaded=$? 
if [ $configLoaded -eq 0 ]
then
	echo "`date`      Configuration file loaded" >> $log
else
	echo "`date`      Unable to load configuration file, using defaults" >> $log
fi

# get local variables
hostname=$(cat /etc/hostname)
topic=$(echo "$topic_prefix/computers/$hostname")
echo $topic

# wait for incomming messages
while :
do
	msg=$(mosquitto_sub -h $host -p $port -u $username -P $password -C 1 -t "$topic")
	echo $msg
	if [ "$msg" == "poweroff" ]
	then
		echo "`date`      Starting poweroff script" >> $log
		$(dirname "$0")/SC_poweroff.sh
	fi
done
