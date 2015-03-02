#! /bin/bash

# Configuration :
LOCAL_PATH="//capture"
DISTANT_PATH="//synology/capture/"
DELAY_S=7200

REAL_LOCAL_PATH=`realpath "$LOCAL_PATH"`
REAL_DISTANT_PATH=`realpath "$DISTANT_PATH"`

LOOP=0
CLEAN=0

function sync {

	rsync --progress --recursive --times --remove-source-files "$REAL_LOCAL_PATH/" "$REAL_DISTANT_PATH"
}

function clean {
	echo "Cleaning $REAL_DISTANT_PATH"
	./distant-cleaner.sh

}

function loop {

	while [ : ]
	do
		if [ "$CLEAN" -eq 1 ]; then
			clean
    		fi
		sync
    		echo "Done! next copy in $DELAY_S sec."	
    		sleep $DELAY_S
	done
}


while getopts ":lc" opt; do
  case $opt in
    l)
      echo "Loop mode is ON" ; LOOP=1 
      ;;
    c)
      echo "Cleaning is ON" ; CLEAN=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 
      ;;
  esac
done

if [ "$LOOP" -eq 1 ]; then
	 loop
else
	if [ "$CLEAN" -eq 1 ]; then
        	clean
        fi
	sync
	echo "Done!"
fi
