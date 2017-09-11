#!/bin/bash

# make sure this script is ran as the right user!!!!!

export DISPLAY=$2
xhost local:$1

(
for i in `seq 100 -1 1`;
do
        abort=`wget -qO- "http://unipi:8080/rest/items/abortShutdown/state"`

        if [ "$abort" = "ON" ] ; then
		exit 1
	fi

	countdown=$(($i/5))
	if [ $i = 100 ] ; then
		i=$((99))
	fi

	echo $i
	echo "#This system will be shutdown by Spacecontrol in $countdown seconds.\nClick cancel to abort."
	sleep 0.18
done
) | zenity --progress --title="Spacecontrol Poweroff" --text="The Space and this system will be shutdown by Spacecontrol in 20 seconds. \nClick cancel to abort shutdown." --percentage=100 --auto-close

