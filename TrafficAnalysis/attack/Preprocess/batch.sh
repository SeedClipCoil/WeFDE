#!/bin/bash






# CS-BuFLO

#python Extract.py cs_buflo







# WTF_NORMAL 
python Extract.py WTF_NORMAL 












# supersequence

#for cluster in 2 4 6 8 10 20 35 50
#do
#  echo $cluster
#  python Extract.py supersequence_method4supercluster2_clusternum$cluster\_stoppoints4 
#done
#
#echo started method3
#
#for super in 2 5 10
#do
#  echo $super
#  for stop in 4 8 12
#  do
#    python Extract.py supersequence_method3supercluster$super\_clusternum20_stoppoints$stop
#  done
#done

# WTF-PAD_0.9


#python Extract.py closew_defense/top100/WTF_0.9
#python Extract.py openw_defense/non_monitor_0-500/WTF_0.9
#python Extract.py openw_defense/non_monitor_1500-2000/WTF_0.9
#python Extract.py openw_defense/non_monitor_500-1500/WTF_0.9





## buflo
#for i in 20 60 120
#do
#  python Extract.py closew_defense/top100/buflo_$i
#  python Extract.py openw_defense/non_monitor_0-500/buflo_$i
#  python Extract.py openw_defense/non_monitor_1500-2000/buflo_$i
#  python Extract.py openw_defense/non_monitor_500-1500/buflo_$i
#done
#
#
#for i in 100 500 1000
#do
#  # tamaraw no
#  python Extract.py closew_defense/top100/tamaraw_no_obfuscate_$i
#  python Extract.py openw_defense/non_monitor_0-500/tamaraw_no_obfuscate_$i
#  python Extract.py openw_defense/non_monitor_1500-2000/tamaraw_no_obfuscate_$i
#  python Extract.py openw_defense/non_monitor_500-1500/tamaraw_no_obfuscate_$i
#
#  # tamaraw with
#  python Extract.py closew_defense/top100/tamaraw_with_obfuscate_$i
#  python Extract.py openw_defense/non_monitor_0-500/tamaraw_with_obfuscate_$i
#  python Extract.py openw_defense/non_monitor_1500-2000/tamaraw_with_obfuscate_$i
#  python Extract.py openw_defense/non_monitor_500-1500/tamaraw_with_obfuscate_$i
#done
#
#
#python Extract.py closew_defense/top100/tamaraw_no_obfuscate_1000
#python Extract.py closew_defense/top100/tamaraw_no_obfuscate_1000
#python Extract.py closew_defense/top100/tamaraw_no_obfuscate_1000
#python Extract.py closew_defense/top100/tamaraw_no_obfuscate_1000
#
#
# python Extract.py top100/tamaraw_no_obfuscate_1000

#python Extract.py non_monitor_0-500/tamaraw_no_obfuscate_1000
#python Extract.py non_monitor_500-1500/tamaraw_no_obfuscate_1000
#python Extract.py non_monitor_1500-2000/tamaraw_no_obfuscate_1000


#for i in {8..9..1}
#do
#  echo $i
#  python Extract.py WTF_0.$i
#done
#






#python Extract.py buflo_5
#python Extract.py buflo_10
#python Extract.py buflo_20
#python Extract.py buflo_30
#python Extract.py buflo_40
#python Extract.py buflo_50
#python Extract.py buflo_60
#python Extract.py buflo_80
#python Extract.py buflo_100
#python Extract.py buflo_120


#python Extract.py tamaraw_no_obfuscate_10 &
#python Extract.py tamaraw_no_obfuscate_20 &
#python Extract.py tamaraw_no_obfuscate_30 &
#python Extract.py tamaraw_no_obfuscate_40 &
#python Extract.py tamaraw_no_obfuscate_50 &
#wait
#python Extract.py tamaraw_no_obfuscate_60 &
#python Extract.py tamaraw_no_obfuscate_70 &
#python Extract.py tamaraw_no_obfuscate_80 &
#python Extract.py tamaraw_no_obfuscate_90 &
#python Extract.py tamaraw_no_obfuscate_100 &
#wait
#python Extract.py tamaraw_no_obfuscate_200 &
#python Extract.py tamaraw_no_obfuscate_300 &
#python Extract.py tamaraw_no_obfuscate_400 &
#python Extract.py tamaraw_no_obfuscate_500 &
#python Extract.py tamaraw_no_obfuscate_600 &
#wait
#python Extract.py tamaraw_no_obfuscate_700 &
#python Extract.py tamaraw_no_obfuscate_800 &
#python Extract.py tamaraw_no_obfuscate_900 &
#python Extract.py tamaraw_no_obfuscate_1000 &
#wait
#
#python Extract.py tamaraw_with_obfuscate_10 &
#python Extract.py tamaraw_with_obfuscate_20 &
#python Extract.py tamaraw_with_obfuscate_30 &
#python Extract.py tamaraw_with_obfuscate_40 &
#python Extract.py tamaraw_with_obfuscate_50 &
#wait
#python Extract.py tamaraw_with_obfuscate_60 &
#python Extract.py tamaraw_with_obfuscate_70 &
#python Extract.py tamaraw_with_obfuscate_80 &
#python Extract.py tamaraw_with_obfuscate_90 &
#python Extract.py tamaraw_with_obfuscate_100 &
#wait
#python Extract.py tamaraw_with_obfuscate_200 &
#python Extract.py tamaraw_with_obfuscate_300 &
#python Extract.py tamaraw_with_obfuscate_400 &
#python Extract.py tamaraw_with_obfuscate_500 &
#python Extract.py tamaraw_with_obfuscate_600 &
#wait
#python Extract.py tamaraw_with_obfuscate_700 &
#python Extract.py tamaraw_with_obfuscate_800 &
#python Extract.py tamaraw_with_obfuscate_900 &
#python Extract.py tamaraw_with_obfuscate_1000 &
#




#python Extract.py closed
#python Extract.py buflo_10 
#python Extract.py buflo_50 
#python Extract.py tamaraw_no_obfuscate 
#python Extract.py tamaraw_with_obfuscate 
#python Extract.py glove 
##python Extract.py monitor
#python Extract.py non_monitor_0-500
#python Extract.py non_monitor_1500-2000
#python Extract.py non_monitor_500-1500

#python FeatureMatrix.py buflo_50
#python FeatureMatrix.py tamaraw_no_obfuscate
#python FeatureMatrix.py tamaraw_with_obfuscate 
#python FeatureMatrix.py glove 
