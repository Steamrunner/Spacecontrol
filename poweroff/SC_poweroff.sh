#!/bin/bash

#log to script
echo "`date`      script started." >> SC_poweroff.log

#find desktop user if any
user=`who | grep :0`
set -- $user
user=$1

if [ -z $user ] ; then
	echo "`date`      No logged in user found" >> SC_poweroff.log
	exit 0
fi

echo "`date`      Logged in user \"$user\" found" >> SC_poweroff.log

#showing the countdown/cancel window
sudo -H -u $user /home/shutdownuser/spacecontrol/poweroff/SC_poweroff_popup.sh $user

if [ $? = 1 ] ; then
	echo "`date`      Poweroff canceled by local user" >> SC_poweroff.log
	/usr/bin/wget -qO- "http://unipi:8080/CMD?AbortShutdown=ON" >> /dev/null
	exit 1
else
	abort=`wget -qO- "http://unipi:8080/rest/items/AbortShutdown/state"`

	if [ $abort = "OFF" ] ; then
	        echo "`date`      Powering down system" >> SC_poweroff.log
		sudo /sbin/shutdown -h now
	else
		echo "`date`      Poweroff canceled by SpaceControl" >> SC_poweroff.log
	fi
	exit 0
fi
