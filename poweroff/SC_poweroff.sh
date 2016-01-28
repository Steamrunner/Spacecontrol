#!/bin/bash

#log to script
echo "`date`      script started." >> SC_poweroff.log

#find desktop user if any
user=`who | grep :0`
set -- $user
user=$1

echo "`date`      logged in user \"$user\" found" >> SC_poweroff.log

#showing the countdown/cancel window
sudo -u $user "./SC_poweroff_popup.sh"

if [ $? = 1 ] ; then
	echo "`date`      Poweroff canceled by local user" >> SC_poweroff.log
	/usr/bin/wget -qO- "http://unipi:8080/CMD?Abort=ON" >> /dev/null
	exit 1
else
	abort=`wget -qO- "http://unipi:8080/rest/items/Abort/state"`

	if [ $abort = "OFF" ] ; then
	        echo "`date`      Powering down system" >> SC_poweroff.log
		sudo /sbin/shutdown -h now
	else
		echo "`date`      Poweroff canceled by SpaceControl" >> SC_poweroff.log
	fi
	exit 0
fi
