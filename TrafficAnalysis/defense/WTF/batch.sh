#!/bin/bash


for i in 9 
do
  echo $i
  python main.py $i &
done
wait
