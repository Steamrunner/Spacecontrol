#!/bin/bash

whoResults=$(who | grep '(:[0-9])')

echo 'whoResults' $whoResults 'end'

if [ "$whoResults" = $'\n' ] ; then
  echo "FOUND NEWLINE"
fi


readarray -t whoResultLines <<< "$whoResults"

echo "--------------------------------------"

len=${#whoResultLines[@]}
len=${$whoResultLines[@] | wc -w}

echo $len

if [ ${#whoResultLines[@]} -eq 0 ]; then
    echo "No errors, hooray"
else
    echo "Oops, something went wrong..."
fi

for (( i=0; i<${len}; i++ ));
do
	set -- ${whoResultLines[$i]}
	user=$1
	display=${5:1:2}
	echo $user $display
done

echo $len

if (( $len > 2 )) ; then

	echo 'found'

fi


echo "--------------------------------------"

