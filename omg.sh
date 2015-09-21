#! /bin/bash

FILENAME=$1

EXTEN=$2

BASEN=${FILENAME%.*}

sox $FILENAME ${BASEN}_trimfade${EXTEN} trim 0.0 5.0 fade 0.1 =5.0 norm

sox $FILENAME ${BASEN}_trimfadereverb${EXTEN} trim 0.0 4.0 fade 0.1 =4.0 0.1  reverb -w norm

sox $FILENAME ${BASEN}_trimfadebroken${EXTEN} trim 0.0 1.0 speed 0.5 overdrive 20 80 chorus 0.7 0.9 55 0.4 0.25 2 -s bandpass 500 10 overdrive 70 70 trim 0.0 2.0 fade 0.1 =2.0 0.1 gain -n

sox $FILENAME ${BASEN}_weird${EXTEN} trim 0.0 12.0 speed 2.0 remix 1 2 1 2 delay 5 7 remix 1,4 2,3 echos 0.8 0.7 15 0.6 50 0.8 30 0.7 200 0.5 trim 0.0 6.0 fade 0.1 =6.0 0.1 gain -n

echo "Done"
