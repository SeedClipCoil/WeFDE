import csv



rank = dict()

fd = open('closed.csv', 'w')


for i in range(0,200):
	rank[i] = i + 1

fcsv = csv.writer(fd)

for key, val in rank.items():
	fcsv.writerow([key, val])

fd.close()
