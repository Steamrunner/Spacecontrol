#!/bin/bash

#log to script
echo "`date`      script started." >> SC_poweroff.log

# get a list of users logged into a graphical session
whoResults=$(who | grep ' :[0-9]')

# transform the result string into an array
IFS='\n' readarray whoArray <<< "$whoResults"

# stop the program if no one is logged in
# if no one is logged in this code returns an array containing empty element 
if [ ${#whoArray[@]} == 1 ] ; then
	if [ "$(echo -ne ${whoArray} | wc -m)" -eq 0 ]; then
	        echo "`date`      No logged in user found" >> SC_poweroff.log
		exit 0
	fi
fi

# start the countdown windows on every display with logged in user
pids=()
for i in "${whoArray[@]}" ; do
	set -- $i
	echo "`date`      Logged in user \"$1\" on display \"$2\" found" >> SC_poweroff.log
	sudo -H -u $1 /home/shutdownuser/spacecontrol/poweroff/SC_poweroff_popup.sh $1 $2 &
	pids+=($!)
done

# wait for countdownwindows to be closed
exitcode=0
for i in "${pids[@]}" ; do
	wait $i
	((exitcode|=($?)))
done

if [ $exitcode = 1 ] ; then
	# shutdown was aborted by a user on this machine
	# set abortShutdown in spacecontrol to ON
        echo "`date`      Poweroff canceled by local user" >> SC_poweroff.log
        /usr/bin/wget -qO- "http://unipi:8080/CMD?abortShutdown=ON" >> /dev/null
        exit 1
else
	# shutdown was NOT aborted on this machine
	# check if shutdown was not aborted on spacecontrol
        abort=`wget -qO- "http://unipi:8080/rest/items/AbortShutdown/state"`

        if [ $abort = "OFF" ] ; then
                echo "`date`      Powering down system" >> SC_poweroff.log
                sudo /sbin/shutdown -h now
        else
                echo "`date`      Poweroff canceled by SpaceControl" >> SC_poweroff.log
        fi
        exit 0
fi
