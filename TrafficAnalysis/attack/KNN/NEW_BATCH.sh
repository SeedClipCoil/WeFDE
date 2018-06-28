#!/bin/bash


for i in {10..90..10}
do
  echo $i
  ./run tamaraw_no_obfuscate_$i > tamaraw_no_obfuscate_$i.results &
  ./run tamaraw_with_obfuscate_$i > tamaraw_with_obfuscate_$i.results &
  if [ $i == 30 ] || [ $i == 60 ] || [ $i == 90 ]; then
    wait
  fi
done
