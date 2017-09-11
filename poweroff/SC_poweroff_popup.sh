#!/bin/bash

# make sure this script is ran as the right user!!!!!

export DISPLAY=$2
xhost local:$1

(
for i in `seq 200 -1 1`;
do
        abort=`wget -qO- "http://unipi:8080/rest/items/abortShutdown/state"`

        if [ "$abort" = "ON" ] ; then
		exit 1
	fi

	seqNumber=$((5*$i))
	if [ $seqNumber = 100 ] ; then
		seqNumber=$((99))
	fi
	echo $seqNumber
	echo "#This system will be shutdown by Spacecontrol in $i seconds.\nClick cancel to abort."
	sleep 0.1
done
) | zenity --progress --title="Spacecontrol Poweroff" --text="The Space and this system will be shutdown by Spacecontrol in 20 seconds. \nClick cancel to abort shutdown." --percentage=1000 --auto-close

