import os, sys
import csv

NON_RANK = "csv/1500-2500_add.csv"
RANK = "csv/top-1m.csv"




def RankList(key):
	global RANK
	fd = open(RANK, 'r')
	for rnk, wname in csv.reader(fd):
		if wname == key:
			return rnk
	return 0



def Purify(line):
	return line.split("http://www.")[1].strip()



def ObtainRank(NON_RANK, RANK):
	ID_RANK = dict()
	
	fd = open(NON_RANK, 'r')
	
	for idx, each_line in enumerate(fd.readlines()):
		key = Purify(each_line)
		rnk = RankList(key)
		if rnk != 0:
			ID_RANK[idx] = rnk
		else:
			print "not found: ", key
	
	
	fd.close()
	
	dfile = "non_monitor_" NON_RANK.split('/')[1].split('_')[0] + ".csv"
	f = open(dfile, 'w')
	fcsv = csv.writer(f)
	for key, val in ID_RANK.items():
		fcsv.writerow([key, val])
	f.close()






if __name__ == "__main__":
	ObtainRank(NON_RANK, RANK)
	
