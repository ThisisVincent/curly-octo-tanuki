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
      echo "error," $1 "format not recognized"
    fi
  elif [ $1 == "-output" ]; then
    shift
    if [ $1 == ".wav" ] || [ $1 == ".mp3" ]; then
      echo "output will be in" $1 "format"
      OXT=$1
    else
    echo "error," $1 "format not recognized"
    fi
  fi
}

function pprocess {
  for file in *$2; do
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
    echo "Done"
  done
  # if [ $2 -n ]; then
  #  cd..
  # fi
}

function checkopt {
  for ((i = 1; i <= $#; i+1 )); do
     checkifoption $*
     echo $*
    shift
  done
}

function ppp {
  for file in *$1; do
    BASEN=${file%.*}
    mkdir trimfade
    sox $file trimfade/${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 =5.0 norm
  done
}

function aaa {
 echo $*

}

OXT=".wav"
IXT=".wav"


if [ -n $# ]; then
  checkopt $*
fi
if [ INTPUTEXTN == "both" ]; then
  pprocess $OUTPUTEXTN .wav
  pprocess $OUTPUTEXTN .mp3
else
  pprocess $OXT $IXT
fi
