#! /bin/bash

OFILENAME=$1
OEXT=${OFILENAME##*.}
BASEN=${OFILENAME%.*}
EXTEN=$2

if [ $OEXT != "wav" ]; then lame $OFILENAME ${BASEN}.wav
  FILENAME=${BASEN}.wav
else FILENAME=$OFILENAME
fi

sox $FILENAME ${BASEN}_trimfade${EXTEN} trim 0.0 5.0 fade 0.1 =5.0 norm

sox $FILENAME ${BASEN}_trimfadereverb${EXTEN} trim 0.0 4.0 fade 0.1 =4.0 0.1  reverb -w norm

sox $FILENAME ${BASEN}_trimfadebroken${EXTEN} trim 0.0 1.0 speed 0.5 overdrive 20 80 chorus 0.7 0.9 55 0.4 0.25 2 -s bandpass 500 10 overdrive 70 70 trim 0.0 2.0 fade 0.1 =2.0 0.1 gain -n

sox $FILENAME ${BASEN}_weird${EXTEN} trim 0.0 12.0 speed 2.0 remix 1 2 1 2 delay 5 7 remix 1,4 2,3 echos 0.8 0.7 15 0.6 50 0.8 30 0.7 200 0.5 trim 0.0 6.0 fade 0.1 =6.0 0.1 gain -n

# if [$OFILENAME != $FILENAME]; then


echo "Done"
