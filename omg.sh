#! /bin/bash

FILENAME=$1

BASEN=${FILENAME%.*}

sox --norm $FILENAME ${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 5.0

sox --norm $FILENAME ${BASEN}_trimfadereverse.wav trim 0.0 4.0 fade 0.1 4.0 0.1  reverb -w 

echo "Done"
