#!/bin/bash


for super in 2
do
	echo $super 
	for st in 4
	do
    for cluster in 2 4 6 8 10 20 35 50
    do
		  python cluster.py $cluster $super $st 4 > output/output_method4_super$super\_st$st\_cluster$cluster &
      if [ $cluster == 8 ]; then
        wait
      fi
    done
	done
done

wait
