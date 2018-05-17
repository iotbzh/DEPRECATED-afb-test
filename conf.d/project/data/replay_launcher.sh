#!/bin/bash

PLAYER=$(which canplayer)
FILE=$1

if [ $PLAYER ]
then
	$PLAYER -I $FILE &
else
	echo "can-utils packages not installed"
	exit 1
fi

exit 0
