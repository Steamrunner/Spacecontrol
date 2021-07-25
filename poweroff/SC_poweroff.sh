#!/usr/bin/env bash

# set defaults
log=poweroffd.log

#log to script
echo "`date`      script started." >> $log

# get a list of users logged into a graphical session
whoResults=$(who | grep '(:[0-9])')

# transform the result string into an array
IFS='\n' readarray whoArray <<< "$whoResults"

# stop the program if no one is logged in
# if no one is logged in this code returns an array containing empty element 
if [ ${#whoArray[@]} == 1 ] ; then
	if [ "$(echo -ne ${whoArray} | wc -m)" -eq 0 ]; then
		# check for tty1
		whoResults=$(who | grep 'tty1')
		whoResults="$whoResults (:0)"
		IFS='\n' readarray whoArray <<< "$whoResults"
		if [ "$(echo -ne ${whoArray} | wc -m)" -eq 0 ]; then
			# still nothing:
	        	echo "`date`      No logged in user found" >> $log
			exit 0	
		fi
	fi
fi

# start the countdown windows on every display with logged in user
pids=()
for i in "${whoArray[@]}" ; do
	set -- $i
	echo "`date`      Logged in user \"$1\" on display \"${!#:1:2}\" found" >> $log
	SUBSTRING=$(echo ${!#:1:2})
	echo $SUBSTRING
	sudo -H -u $1 $(dirname "$0")/SC_poweroff_popup.sh $1 ${!#:1:2} &	
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
        echo "`date`      Poweroff cancelled by local user" >> $log
 #       /usr/bin/wget -qO- "http://unipi:8080/CMD?abortShutdown=ON" >> /dev/null
        exit 1
else
	# shutdown was NOT aborted on this machine
	# check if shutdown was not aborted on spacecontrol
#        abort=`wget -qO- "http://unipi:8080/rest/items/abortShutdown/state"`

#        if [ "$abort" = "OFF" ] ; then
                echo "`date`      Powering down system" >> $log
		sudo /sbin/shutdown -h now
		if [ $? -ne 0 ] ; then
			systemctl poweroff -i
		fi
#        else
#                echo "`date`      Poweroff cancelled by SpaceControl" >> $log
#        fi
        exit 0
fi
