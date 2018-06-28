#!/bin/bash



# cs_buflo 


./run cs_buflo > cs_buflo.results







## supersequence
#for cluster in 2 4 6 8 10 20 35 50
#do
#  echo $cluster
#  ./run supersequence_method4supercluster2_clusternum$cluster\_stoppoints4> supersequence_method4supercluster2_clusternum$cluster\_stoppoints4.results & 
#
#done
#
#echo started method3
#
#for super in 2 5 10
#do
#  echo $super
#  for stop in 4 8 12
#  do
#    ./run supersequence_method3supercluster$super\_clusternum20_stoppoints$stop > supersequence_method3supercluster$super\_clusternum20_stoppoints$stop.results &
#  done
#done
#
#



# WTF-Padding

#for i in {1..9..1} 
#do
#	./run WTF_0.$i > WTF_0.$i.results & 
#	if [ $i == 9 ]; then
#		wait
#	fi
#done












# ./run buflo_5 > buflo_5.results &
#./run buflo_10 > buflo_10.results &
#wait
#./run buflo_20 > buflo_20.results &
#wait
#./run buflo_30 > buflo_30.results &
#wait
#./run buflo_40 > buflo_40.results &
#wait
#./run buflo_50 > buflo_50.results &
#wait
#./run buflo_60 > buflo_60.results &
#wait
#./run buflo_80 > buflo_80.results &
#wait
#./run buflo_100 > buflo_100.results &
#wait
#./run buflo_120 > buflo_120.results &
#wait
#



#./run tamaraw_no_obfuscate_200 > tamaraw_no_obfuscate_200.results &
#./run tamaraw_no_obfuscate_400 > tamaraw_no_obfuscate_400.results &
#wait
#./run tamaraw_no_obfuscate_800 > tamaraw_no_obfuscate_800.results & 
#./run tamaraw_no_obfuscate_300 > tamaraw_no_obfuscate_300.results &
#./run tamaraw_no_obfuscate_500 > tamaraw_no_obfuscate_500.results &
#wait
#./run tamaraw_no_obfuscate_600 > tamaraw_no_obfuscate_600.results &
#wait
#./run tamaraw_no_obfuscate_700 > tamaraw_no_obfuscate_700.results &
#wait
#./run tamaraw_no_obfuscate_900 > tamaraw_no_obfuscate_900.results &
#wait
#./run tamaraw_with_obfuscate_100 > tamaraw_with_obfuscate_100.results &
#./run tamaraw_with_obfuscate_400 > tamaraw_with_obfuscate_400.results &
#wait
#./run tamaraw_with_obfuscate_800 > tamaraw_with_obfuscate_800.results & 
#./run tamaraw_with_obfuscate_1000 > tamaraw_with_obfuscate_1000.results &
#wait

#./run tamaraw_with_obfuscate_200 > tamaraw_with_obfuscate_200.results &
#wait
#./run tamaraw_with_obfuscate_300 > tamaraw_with_obfuscate_300.results &
#wait
#./run tamaraw_with_obfuscate_500 > tamaraw_with_obfuscate_500.results &
#wait
#./run tamaraw_with_obfuscate_600 > tamaraw_with_obfuscate_600.results &
#wait
#./run tamaraw_with_obfuscate_700 > tamaraw_with_obfuscate_700.results &
#wait
#./run tamaraw_with_obfuscate_900 > tamaraw_with_obfuscate_900.results &
#wait
#
