#!/bin/bash

whoResults=$(who | grep ' :[0-9]')

echo -e "whoResults\n${whoResults}\nend"

IFS='\n' readarray array <<< "$whoResults"

echo "array0:" $array[0]
echo "array1:" $array[1]
echo "array lenght: ${#array[@]}"


if [ "$whoResults" = $'\c' ] ; then
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

