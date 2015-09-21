#! /bin/bash

FILENAME=$1

BASEN=${FILENAME%.*}

echo $BASEN

sox --norm $FILENAME ${BASEN}_trimfade.wav trim 0.0 5.0 fade 0.1 5.0

echo "Done"
