#!/bin/bash

# supersequence

for cluster in 2 4 6 8 10 20 35 50
do
  echo $cluster
  python3 FeatureMatrix.py supersequence_method4supercluster2_clusternum$cluster\_stoppoints4 
done

echo started method3

for super in 2 5 10
do
  echo $super
  for stop in 4 8 12
  do
    python3 FeatureMatrix.py supersequence_method3supercluster$super\_clusternum20_stoppoints$stop
  done
done






## WTF

#for i in {6..9..1} 
#do
#  echo $i
#  python3 FeatureMatrix.py WTF_0.$i &
#done
#
#wait
#





## TAMARAW 
#for i in 10 20 30 40 50 60 70 80 90
#do
#  python3 FeatureMatrix.py tamaraw_no_obfuscate_$i
#  python3 FeatureMatrix.py tamaraw_with_obfuscate_$i
#done

