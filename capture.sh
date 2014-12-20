#! /bin/bash

# Configuration :
SAVE_PATH="./capture"
DELAY_S=300
FILE_PREFIX="flower"


REAL_PATH=`realpath "$SAVE_PATH"`

while [ : ]
do
    	gpio -g write 18 1
	raspistill -o "$REAL_PATH"/"$FILE_PREFIX"-`date +"%m-%d-%y@%H:%M:%S"`.jpg
    	gpio -g write 18 0
	sleep $DELAY_S
done
