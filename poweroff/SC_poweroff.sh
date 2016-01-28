#!/bin/bash

#log to script
echo "`date`      script started." >> SC_poweroff.log

#find desktop user if any
user=`who | grep :0`
set -- $user
user=$1

echo "`date`      logged in user \"$user\" found" >> SC_poweroff.log

#showing the countdown/cancel window
sudo su $user -c "./SC_poweroff_popup.sh"

if [ $? = 1 ] ; then
	echo "`date`      Poweroff canceled" >> SC_poweroff.log
	exit 1
else
	echo "`date`      Powering down system" >> SC_poweroff.log
	/sbin/poweroff
	exit 0
fi
