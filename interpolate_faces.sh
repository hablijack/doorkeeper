#!/bin/bash
PIDFILE=/home/chrhab/surveillance_record/interpolate_faces.pid

function cleanup_tmp_jpg {
  rm -f /home/chrhab/surveillance_record/jpg/*.jpg
}

function cleanup_tmp_avi {
  rm -f /home/chrhab/surveillance_record/raw/*.avi
}

if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    #echo "Process already running"
    exit 1
  else
    ## Process not found assume not running
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      #echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]
  then
    #echo "Could not create PID file"
    exit 1
  fi
fi

if ls /home/chrhab/surveillance_record/raw/*.avi 1> /dev/null 2>&1; then
  cleanup_tmp_jpg
  /usr/bin/ffmpeg -threads 4 -i /home/chrhab/surveillance_record/raw/*.avi -r 3 -s 1280x720 -f image2 /home/chrhab/surveillance_record/jpg/extracted-%03d.jpg
  cleanup_tmp_avi
  /usr/bin/python3 /home/chrhab/surveillance_record/face_recognition_cli.py --show-distance false --cpus 4 /home/chrhab/surveillance_record/known_faces/ /home/chrhab/surveillance_record/jpg >> /home/chrhab/surveillance_record/result.txt
  cleanup_tmp_jpg
fi

rm $PIDFILE
