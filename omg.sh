#! /bin/bash
# Vincent Pruijn Perez, 2015
echo "This script will standard be executed in  it's current directory,
 and will use the .wav format for both input and output.
 It is posible to modify any of this parameters using the options,
 being this -input, -output and -directory.
 Suggested command: ./omg.sh -input .mp3 -output .mp3 -directory sox_fragments/
"

function checkifoption {
  if [ $1 == "-input" ]; then
    shift
    if [ $1 == ".wav" ] || [ $1 == ".mp3" ]; then
      echo "Input will be in" $1 "format"
      IXT=$1
    elif [ $1 == "both" ]; then
      echo "Files in .wav and .mp3 will be processed"
    else
      echo "Error," $1 "format not recognized, intput will be in .wav format"
    fi
  elif [ $1 == "-output" ]; then
    shift
    if [ $1 == ".wav" ] || [ $1 == ".mp3" ]; then
      echo "Output will be in" $1 "format"
      OXT=$1
    else
      echo "Error," $1 "format not recognized, output will be in .wav format"
    fi
  elif [ $1 == "-directory" ]; then
    shift
    if [ -d $1 ]; then
      cd $1
    else
      echo "Folder not found"
    fi
  fi
}

function pprocess {
  echo "Starting process"
  for file in *$2; do
    OFILENAME=$file
    OEXT=${OFILENAME##*.}
    BASEN=${OFILENAME%.*}
    EXTEN=$1

    if [ $OEXT != "wav" ]; then lame --decode $OFILENAME ${DIR0}/${BASEN}.wav
      FILENAME=${DIR0}/${BASEN}.wav
    else FILENAME=$OFILENAME
    fi
    local randd=$(( ( RANDOM % 300 )  + 400 ))
    sox $FILENAME ${DIR0}/${DIR1}/${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 =5.0 channels 2 norm -3.0
    sox $FILENAME ${DIR0}/${DIR2}/${BASEN}_trimfadereverb.wav trim 0.0 4.0 fade 0.1 =4.0 0.1  reverb -w lowpass 700 channels 2 norm -3.0
    sox $FILENAME ${DIR0}/${DIR3}/${BASEN}_trimfadebroken.wav trim 0.0 1.0 speed 0.5 overdrive 20 80 chorus 0.7 0.9 55 0.4 0.25 2 -s bandpass $randd 10 overdrive 70 70 trim 0.0 2.0 fade 0.1 =2.0 0.1 channels 2 gain -n -3.0
    sox $FILENAME ${DIR0}/${DIR4}/${BASEN}_weird.wav channels 2 trim 0.0 12.0 speed 2.0 remix 1 2 1 2 delay 5 7 remix 1,4 2,3 echos 0.8 0.7 15 0.6 50 0.8 30 0.7 100 0.5 trim 0.0 6.0 fade 0.1 =6.0 0.1 gain -n -3.0

    IX=$(( $IX + 1 ))
    cp ${DIR0}/${DIR1}/${BASEN}_trimfade.wav ${DIR0}/${DIR6}/${IX}.wav
    IX=$(( $IX + 1 ))
    cp ${DIR0}/${DIR2}/${BASEN}_trimfadereverb.wav ${DIR0}/${DIR6}/${IX}.wav
    IX=$(( $IX + 1 ))
    cp ${DIR0}/${DIR3}/${BASEN}_trimfadebroken.wav ${DIR0}/${DIR6}/${IX}.wav
    IX=$(( $IX + 1 ))
    cp ${DIR0}/${DIR4}/${BASEN}_weird.wav ${DIR0}/${DIR6}/${IX}.wav

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
    DIR=${DIR}new
  done
  mkdir $DIR
  echo $DIR
}

function tempcopydir {
  echo "Generating composition..."
  IIX=0
  for file in ${DIR0}/${DIR6}/*.wav; do
    IIX=$(( $IIX + 1 ))
    local randd1=$(( ( RANDOM % 10 )  + 1 ))
    local randd2=0.${randd1}0
    local randd3=$(( ( RANDOM % 10 )  + 1 ))
    local randd4=0.${randd1}0
    local randd5=$(( ( RANDOM % 6 )  + 1 ))
    local randd6=-${randd1}.0
    sox $file ${DIR0}/${DIR7}/${IIX}.wav trim $randd2 $randd4 rate -L -s 44100 gain $randd6
    rm $file
  done
  rmdir ${DIR0}/${DIR6}
}

function composition {
  echo "..."
  sox -n -r 44100 -c 2 ${DIR0}/${DIR5}/compold.wav trim 0.0 1.0
  for file in ${DIR0}/${DIR7}/*.wav; do
    sox $file ${DIR0}/${DIR5}/compold.wav ${DIR0}/${DIR5}/comp.wav
    rm ${DIR0}/${DIR5}/compold.wav
    rm $file
    mv ${DIR0}/${DIR5}/comp.wav ${DIR0}/${DIR5}/compold.wav
  done
  sox ${DIR0}/${DIR5}/compold.wav ${DIR0}/${DIR5}/compold2.wav reverse
  sox -M ${DIR0}/${DIR5}/compold.wav ${DIR0}/${DIR5}/compold2.wav ${DIR0}/${DIR5}/comp.wav remix 1,3 2,4
  rm ${DIR0}/${DIR5}/compold.wav
  rm ${DIR0}/${DIR5}/compold2.wav
  rmdir ${DIR0}/${DIR7}
  echo "Done"
  if [ $OXT != ".wav" ]; then
    lame ${DIR0}/${DIR5}/comp.wav ${DIR0}/${DIR5}/comp${OXT}
    rm ${DIR0}/${DIR5}/comp.wav
  fi
}

OXT=".wav"
IXT=".wav"

if [ -n $# ]; then
  checkopt $*
fi


IX=0
DIR0=$(checkdirectory edit)
cd $DIR0
DIR1=$(checkdirectory trimfade)
DIR2=$(checkdirectory trimfadereverb)
DIR3=$(checkdirectory trimfadebroken)
DIR4=$(checkdirectory weird)
DIR5=$(checkdirectory composition)
DIR6=$(checkdirectory .temp1)
DIR7=$(checkdirectory .temp2)
cd ..
DIR8=$(pwd)

echo $0 "will be executed in "$DIR8", the resulting files will be created in" ${DIR8}/${DIR0}
echo "Do you want to proceed? (y/n)"
read answer
if [ $answer == "y" ]; then
  echo "Proceeding..."
  if [ INTPUTEXTN == "both" ]; then
    pprocess $OXT .wav
    pprocess $OXT .mp3
  else
    pprocess $OXT $IXT
  fi
  tempcopydir
  composition
else
  echo "Operation canceled..."
fi
