#! /bin/bash

function checkifoption {
  if [ $1 == "-input" ]; then
  shift
    if [ $1 == ".wav" ] || [ $1 == ".mp3" ]; then
      echo "input will be in" $1 "format"
      IXT=$1
    elif [ $1 == "both" ]; then
      echo "files in .wav and .mp3 will be processed"
    else
      echo "error," $1 "format not recognized, intput will be in .wav format"
    fi
  elif [ $1 == "-output" ]; then
    shift
    if [ $1 == ".wav" ] || [ $1 == ".mp3" ]; then
      echo "output will be in" $1 "format"
      OXT=$1
    else
    echo "error," $1 "format not recognized, output will be in .wav format"
    fi
  fi
}

function pprocess {
  for file in *$2; do
    OFILENAME=$file
    OEXT=${OFILENAME##*.}
    BASEN=${OFILENAME%.*}
    EXTEN=$1

    if [ $OEXT != "wav" ]; then lame --decode $OFILENAME ${DIR0}/${BASEN}.wav
      FILENAME=${DIR0}/${BASEN}.wav
    else FILENAME=$OFILENAME
    fi
    sox $FILENAME ${DIR0}/${DIR1}/${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 =5.0 norm -3
    sox $FILENAME ${DIR0}/${DIR2}/${BASEN}_trimfadereverb.wav trim 0.0 4.0 fade 0.1 =4.0 0.1  reverb -w lowpass 700 norm -3
    sox $FILENAME ${DIR0}/${DIR3}/${BASEN}_trimfadebroken.wav trim 0.0 1.0 speed 0.5 overdrive 20 80 chorus 0.7 0.9 55 0.4 0.25 2 -s bandpass 500 10 overdrive 70 70 trim 0.0 2.0 fade 0.1 =2.0 0.1 gain -n -3
    sox $FILENAME ${DIR0}/${DIR4}/${BASEN}_weird.wav channels 2 trim 0.0 12.0 speed 2.0 remix 1 2 1 2 delay 5 7 remix 1,4 2,3 echos 0.8 0.7 15 0.6 50 0.8 30 0.7 100 0.5 trim 0.0 6.0 fade 0.1 =6.0 0.1 gain -n -3

    if [ $EXTEN != ".wav" ]; then
    lame ${DIR0}/${DIR1}/${BASEN}_trimfade.wav ${DIR0}/${DIR1}/${BASEN}_trimfade$EXTEN
    rm ${DIR0}/${DIR1}/${BASEN}_trimfade.wav
    lame ${DIR0}/${DIR2}/${BASEN}_trimfadereverb.wav ${DIR0}/${DIR2}/${BASEN}_trimfadereverb$EXTEN
    rm ${DIR0}/${DIR2}/${BASEN}_trimfadereverb.wav
    lame ${DIR0}/${DIR3}/${BASEN}_trimfadebroken.wav ${DIR0}/${DIR3}/${BASEN}_trimfadebroken$EXTEN
    rm ${DIR0}/${DIR3}/${BASEN}_trimfadebroken.wav
    lame ${DIR0}/${DIR4}/${BASEN}_weird.wav ${DIR0}/${DIR4}/${BASEN}_weird$EXTEN
    rm ${DIR0}/${DIR4}/${BASEN}_weird.wav
    fi

    if [ $OFILENAME != $FILENAME ]; then
    rm $FILENAME
    fi
    echo "Done"
  done
}

function checkopt {
  for ((i = 1; i <= $#; i+1 )); do
     checkifoption $*
    shift
  done
}

function checkdirectory() {
  DIR=$1
  while [ -d $DIR ]; do
    DIR=${DIR}copy
  done
    mkdir $DIR
    echo $DIR
}

OXT=".wav"
IXT=".wav"
DIR0=$(checkdirectory edit)
cd $DIR0
DIR1=$(checkdirectory trimfade)
DIR2=$(checkdirectory trimfadereverb)
DIR3=$(checkdirectory trimfadebroken)
DIR4=$(checkdirectory weird)
cd ..
if [ -n $# ]; then
  checkopt $*
fi
if [ INTPUTEXTN == "both" ]; then
  pprocess $OUTPUTEXTN .wav
  pprocess $OUTPUTEXTN .mp3
else
  pprocess $OXT $IXT
fi
