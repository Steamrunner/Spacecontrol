#!/usr/bin/env bash

#todo settings for host port username password
# [-h host] [-p port] [-u username] [-P password]

hostname=$(cat /etc/hostname)
topic=$(echo "/computers/$hostname")

msg=$(mosquitto_sub -C 1 -t "$topic")
while [ "$msg" != "poweroff" ]
do
	msg=$(mosquitto_sub -C 1 -t "$topic")
done

$(dirname "$0")/SC_poweroff.sh

echo "shutdown"

