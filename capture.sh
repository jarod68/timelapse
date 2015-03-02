#! /bin/bash

# Configuration :
SAVE_PATH="//capture"
DELAY_S=30
FILE_PREFIX="street"

#REAL_PATH=`realpath "$SAVE_PATH"`

while [ : ]
do
	DAY_SAVE_PATH="$SAVE_PATH/"`date +"%y-%m-%d"`
    	mkdir -p "$DAY_SAVE_PATH"
	REAL_PATH=`realpath "$DAY_SAVE_PATH"`
	gpio -g write 18 1
	raspistill -o "$REAL_PATH"/"$FILE_PREFIX"-`date +"%m-%d-%y_%Hh%M_%S"`.jpg
    	gpio -g write 18 0
	sleep $DELAY_S
done
