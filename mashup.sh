#! /bin/bash

echo "My name is: $0"
echo "i received $# arguments"
echo "i will make a mashup using $1"

FILENAME=$1

BASENAME = basename $FILENAME .wav

# intro
sox $FILENAME $(BASENAME)_intro.wav trim 9.4 4.3

# Reverse intro
sox ${BASENSME}_intro.wav ${BASENAME}_rev.wav reverse

# Reverb & reverse
sox $FILENAME ${BASENAME}_revreb.wav reverse reverb

# Mashup!!!!!!!!!!!!!
sox --combine concatenate ${BASENAME}_intro.wav ${BASENAME}_rev.wav mashup.wav

echo "Done"
