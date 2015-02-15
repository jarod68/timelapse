#! /bin/bash

# Configuration :

DISTANT_PATH="//synology/capture/"
REAL_DISTANT_PATH=`realpath "$DISTANT_PATH"`
DAY=7

NOW=`date +%s`
AGO=$(($NOW - $DAY * 86400))
echo "Delete older than $DAY day(s)"

for f in "$REAL_DISTANT_PATH"/*
do
	filename=`basename "$f"`
	FILE_DATE=`date --date="$filename" +%s`
	if [[ $FILE_DATE -lt $AGO ]]; then
		echo "deleting $f"
		rm -R "$f"
	fi
done
echo "Clean done!"
