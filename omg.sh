#! /bin/bash

case $# in
  1)
  echo "$0 will be executed in current folder. the input and output file will be in $1 format"
  ;;
  2)
  echo "$0 will be executed in current folder. The i"

esac
if [ $# -lt 1 ]; then
  echo "not enough parameters, input and output file types required."
else [ $# == 1 ]; then

fi
if [ -z "$1" ]; then echo "Error, output extension required."
exit
fi
if [ -n "$2" ] && [ ! -d "$2" ] && ( [ "$2" != ".wav" ] || [ "$2" != ".mp3" ] ); then
  echo "Error, $2 is not an existing directory nor an acceptable extension"
  exit
 elif [ "$2" == ".wav" ] || [ "$2" == ".mp3" ] || [ "$2" == "audio" ]; then
   EXTIN=$2
fi
if [ -n "$3" ] && [ ! -d "$3" ]; then
  echo "Error, $3 is not an existing directory"
  exit
fi
pprocess () {
  for file in $2; do
    OFILENAME=$file
    OEXT=${OFILENAME##*.}
    BASEN=${OFILENAME%.*}
    EXTEN=$1

    if [ $OEXT != "wav" ]; then lame --decode $OFILENAME ${BASEN}.wav
      FILENAME=${BASEN}.wav
    else FILENAME=$OFILENAME
    fi
    mkdir trimfade
    sox $FILENAME trimfade/${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 =5.0 norm
    mkdir trimfadereverb
    sox $FILENAME trimfadereverb/${BASEN}_trimfadereverb.wav trim 0.0 4.0 fade 0.1 =4.0 0.1  reverb -w lowpass 700 norm
    mkdir trimfadebroken
    sox $FILENAME trimfadebroken/${BASEN}_trimfadebroken.wav trim 0.0 1.0 speed 0.5 overdrive 20 80 chorus 0.7 0.9 55 0.4 0.25 2 -s bandpass 500 10 overdrive 70 70 trim 0.0 2.0 fade 0.1 =2.0 0.1 gain -n
    mkdir weird
    sox $FILENAME weird/${BASEN}_weird.wav channels 2 trim 0.0 12.0 speed 2.0 remix 1 2 1 2 delay 5 7 remix 1,4 2,3 echos 0.8 0.7 15 0.6 50 0.8 30 0.7 100 0.5 trim 0.0 6.0 fade 0.1 =6.0 0.1 gain -n

    if [ $EXTEN != ".wav" ]; then
    lame trimfade/${BASEN}_trimfade.wav trimfade/${BASEN}_trimfade$EXTEN
    rm trimfade/${BASEN}_trimfade.wav
    lame trimfadereverb/${BASEN}_trimfadereverb.wav trimfadereverb/${BASEN}_trimfadereverb$EXTEN
    rm trimfadereverb/${BASEN}_trimfadereverb.wav
    lame trimfadebroken/${BASEN}_trimfadebroken.wav trimfadebroken/${BASEN}_trimfadebroken$EXTEN
    rm trimfadebroken/${BASEN}_trimfadebroken.wav
    lame weird/${BASEN}_weird.wav weird/${BASEN}_weird$EXTEN
    rm weird/${BASEN}_weird.wav
    fi

    if [ $OFILENAME != $FILENAME ]; then
    rm $FILENAME
    fi
  done
  # if [ $2 -n ]; then
  #  cd..
  # fi
   echo "Done"
}
checkoptions () {




}

for i in `seq 1 $#`; do
checkoptions $i
done
