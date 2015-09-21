#! /bin/bash

FILENAME=$1

BASENAME = basename $1 .wav

sox  $FILENAME ${BASENAME}_trim.wav trim 3.0 5.0 fade 0.1 0.1

echo "Done"
