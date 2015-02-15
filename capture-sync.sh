#! /bin/bash

# Configuration :
LOCAL_PATH="./capture"
DISTANT_PATH="//synology/capture/"
DELAY_S=7200

REAL_LOCAL_PATH=`realpath "$LOCAL_PATH"`
REAL_DISTANT_PATH=`realpath "$DISTANT_PATH"`

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
		clean
    		sync
    		echo "Done! next copy in $DELAY_S sec."	
    		sleep $DELAY_S
	done
}

LOOP=0

while getopts ":l" opt; do
  case $opt in
    l)
      echo "Loop mode is ON" ; LOOP=1 
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 
      ;;
  esac
done

if [ "$LOOP" -eq 1 ]; then
	 loop
else 
	sync
	echo "Done!"
fi
