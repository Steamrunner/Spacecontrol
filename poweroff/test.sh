#!/bin/bash

whoResults=$(who | grep '(:[0-9])')
readarray -t whoResultLines <<< "$whoResults"

echo "--------------------------------------"

len=${#whoResultLines[@]}

for (( i=0; i<${len}; i++ ));

do
	set -- ${whoResultLines[$i]}
	user=$1
	display=$5
	echo $user $display
done

echo "--------------------------------------"

