#! /bin/bash
for file in *.wav *.mp3 ; do
OFILENAME=$file
OEXT=${OFILENAME##*.}
BASEN=${OFILENAME%.*}
EXTEN=$1

if [ $OEXT != "wav" ]; then lame --decode $OFILENAME ${BASEN}.wav
  FILENAME=${BASEN}.wav
else FILENAME=$OFILENAME
fi

sox $FILENAME ${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 =5.0 norm

sox $FILENAME ${BASEN}_trimfadereverb.wav trim 0.0 4.0 fade 0.1 =4.0 0.1  reverb -w lowpass 700 norm

sox $FILENAME ${BASEN}_trimfadebroken.wav trim 0.0 1.0 speed 0.5 overdrive 20 80 chorus 0.7 0.9 55 0.4 0.25 2 -s bandpass 500 10 overdrive 70 70 trim 0.0 2.0 fade 0.1 =2.0 0.1 gain -n

sox $FILENAME ${BASEN}_weird.wav channels 2 trim 0.0 12.0 speed 2.0 remix 1 2 1 2 delay 5 7 remix 1,4 2,3 echos 0.8 0.7 15 0.6 50 0.8 30 0.7 100 0.5 trim 0.0 6.0 fade 0.1 =6.0 0.1 gain -n
if [ $EXTEN != ".wav" ]; then
lame ${BASEN}_trimfade.wav ${BASEN}_trimfade$EXTEN
rm ${BASEN}_trimfade.wav
lame ${BASEN}_trimfadereverb.wav ${BASEN}_trimfadereverb$EXTEN
rm ${BASEN}_trimfadereverb.wav
lame ${BASEN}_trimfadebroken.wav ${BASEN}_trimfadebroken$EXTEN
rm ${BASEN}_trimfadebroken.wav
lame ${BASEN}_weird.wav ${BASEN}_weird$EXTEN
rm ${BASEN}_weird.wav
fi
if [ $OFILENAME != $FILENAME ]; then
rm $FILENAME
fi
done
echo "Done"
