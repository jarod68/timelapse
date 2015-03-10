#! /bin/bash

# Configuration :
SAVE_PATH="//capture"
DELAY_S=10
FILE_PREFIX="street"
INSTANT_SNAPSHOT_FILENAME="//var/www/capture.jpg"

#REAL_PATH=`realpath "$SAVE_PATH"`

while [ : ]
do
	DAY_SAVE_PATH="$SAVE_PATH/"`date +"%y-%m-%d"`
    	mkdir -p "$DAY_SAVE_PATH"
	REAL_PATH=`realpath "$DAY_SAVE_PATH"`
	gpio -g write 18 1
	FILENAME="$REAL_PATH"/"$FILE_PREFIX"-`date +"%m-%d-%y_%Hh%M_%S"`.jpg
	raspistill -o "$FILENAME"
    	gpio -g write 18 0
	convert "$FILENAME" -pointsize 72 -fill red -annotate +100+100 %[exif:DateTimeOriginal] "$FILENAME"
	cp "$FILENAME" "$INSTANT_SNAPSHOT_FILENAME"
	sleep $DELAY_S
done
