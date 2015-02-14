#! /bin/bash

IMG_SRC_DIST="//freebox/capture-test/"
IMG_SRC_LOCAL="./capture"
IMG_WORKING_DIR="./work-temp"
VIDEO_IN_MUSIC="//freebox/timelapse/input_music"
VIDEO_DEST_LOCAL="./out"
VIDEO_DEST_DIST="//freebox/timelapse"

OUT_FILE_PREFIX="timelapse"

#check directories

if [[ ! -d "$IMG_SRC_DIST" ]]; then
  echo "IMG_SRC_DIST=$IMG_SRC_DIST is not valid path"
  exit
fi
if [[ ! -d "$IMG_SRC_LOCAL" ]]; then
  echo "IMG_SRC_LOCAL=$IMG_SRC_LOCAL is not valid path"
  echo "Creating $IMG_SRC_LOCAL"
  mkdir -p $IMG_SRC_LOCAL || exit
fi
if [[ ! -d "$IMG_WORKING_DIR" ]]; then
  echo "IMG_WORKING_DIR=$IMG_WORKING_DIR is not valid path"
  echo "Creating $IMG_WORKING_DIR"
  mkdir -p $IMG_WORKING_DIR || exit

fi
if [[ ! -d "$VIDEO_IN_MUSIC" ]]; then
  echo "VIDEO_IN_MUSIC=$VIDEO_IN_MUSIC is not valid path"
  exit
fi
if [[ ! -d "$VIDEO_DEST_LOCAL" ]]; then
  echo "VIDEO_DEST_LOCAL=$VIDEO_DEST_LOCAL is not valid path"
  echo "Creating $VIDEO_DEST_LOCAL"
  mkdir -p $VIDEO_DEST_LOCAL || exit
fi
if [[ ! -d "$VIDEO_DEST_DIST" ]]; then
  echo "VIDEO_DEST_DIST=$VIDEO_DEST_DIST is not valid path"
  exit
fi

#Override variable with canonic path :

IMG_SRC_DIST=`readlink -e "$IMG_SRC_DIST"`
IMG_SRC_LOCAL=`readlink -e "$IMG_SRC_LOCAL"`
IMG_WORKING_DIR=`readlink -e "$IMG_WORKING_DIR"`
VIDEO_IN_MUSIC=`readlink -e "$VIDEO_IN_MUSIC"`
VIDEO_DEST_LOCAL=`readlink -e "$VIDEO_DEST_LOCAL"`
VIDEO_DEST_DIST=`readlink -e "$VIDEO_DEST_DIST"`



#sync files :
rsync --delete --progress -ar "$IMG_SRC_DIST/" "$IMG_SRC_LOCAL"

#copy temp and rename

rm -f -R "$IMG_WORKING_DIR"
mkdir -p "$IMG_WORKING_DIR"
mkdir -p "$VIDEO_DEST_LOCAL"
cd "$IMG_SRC_LOCAL"

echo "Copying image to working dir..."

FILE_COUNT=`ls -1 | wc -l`
a=1
for i in *.jpg; do
  new=$(printf "%04d.jpg" "$a") #04 pad to length of 4
  cp "$i" "$IMG_WORKING_DIR/$new"
  echo "$a/$FILE_COUNT copied"
  let a=a+1
done

OUT_FILE_NAME="$OUT_FILE_PREFIX-"`date +"%m-%d-%y@%H:%M:%S"`.mp4
LOCAL_OUT="$VIDEO_DEST_LOCAL/$OUT_FILE_NAME"
DIST_OUT="$VIDEO_DEST_DIST/$OUT_FILE_NAME"

cd "$VIDEO_IN_MUSIC"
ls
MUSIC_FILE=`find . -name  '*.mp3' -print -quit`

MUSIC_OPTION=""

if [[ ! -z "$MUSIC_FILE" ]]; then
	MUSIC_OPTION=' -i ./music.mp3 -c:a copy'
	cp `readlink -e "$MUSIC_FILE"` "$IMG_WORKING_DIR/music.mp3"
	echo "music found : $MUSIC_FILE and copied to $IMG_WORKING_DIR/music.mp3"
fi

cd "$IMG_WORKING_DIR"

avconv -f image2 -i '%04d.jpg'$MUSIC_OPTION -shortest -r 30 -vcodec libx264 "$LOCAL_OUT"
#avconv -f image2 -i '%04d.jpg' -i music.mp3 -c:a copy -r 24 -vcodec libx264 "$LOCAL_OUT"

cp "$LOCAL_OUT" "$DIST_OUT"

//rm -rf "$IMG_WORKING_DIR"
