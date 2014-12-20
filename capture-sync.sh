#! /bin/bash

# Configuration :
LOCAL_PATH="./capture"
DISTANT_PATH="//freebox/capture/"
DELAY_S=3600

REAL_LOCAL_PATH=`realpath "$LOCAL_PATH"`
REAL_DISTANT_PATH=`realpath "$DISTANT_PATH"`

while [ : ]
do
	for f in "$REAL_LOCAL_PATH"/*
	do
    		filename=`basename "$f"`
		echo "copying $filename to $REAL_DISTANT_PATH"
    		cp --preserve=timestamp "$REAL_LOCAL_PATH/$filename" "$REAL_DISTANT_PATH/$filename" && rm "$REAL_LOCAL_PATH/$filename"
	done
    echo "Done! next copy in $DELAY_S sec."	
    sleep $DELAY_S
done
