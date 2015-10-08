#! /bin/bash

# EXT=${FILENAME##*.}
# echo $2
# if [ $EXT != "wav" ]; then echo "y"
# else echo "no"
# fi
# if [ -z "$2" ]; then echo null
# fi
# mkdir $2
# sox $FILENAME ${2}tst1.wav trim 1.0 2.0
# for i in `seq 1 $#`; do
# AA= $%$i
# echo  $1
# echo "aa $#"
# if [ "$i" < "$#" ]; then
# shift
# else
  # echo "stop"
  # exit
# fi
# done
# echo "done for real"
# find . -name \*aac -exec mplayer {} \;

test () {
echo $1
shift 1
echo $1
YOLO="4"
#if [ $# > 0 ];
}
#test "a" $1
#echo $YOLO

function checkifoption {
if [ $1 == "-a" ]; then
  shift
  if [ $1 == ".wav" ] || [ $1 == ".mp3" ]; then
    echo $1
  else
    echo "error"
  fi
fi
}
function checkoption {
if [ $# > 0 ]; then
  if [ $1 == "-a" ]; then
    if [ $# > 1 ]; then
    shift
      if ([ $1 == ".wav" ] || [ $1 == ".mp3" ]); then
        echo $1
        shift
      fi
    fi
  fi
fi
}
function checkopt {
  for i in `seq 1 $#`; do
    checkifoption $@
    shift
  done
}
checkopt $@
