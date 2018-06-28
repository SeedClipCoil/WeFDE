import os, sys
import shutil
import csv


Source = "pathdir/"

datasetSpec = sys.argv[1]


Destination = "Dataset/" + datasetSpec


RANKDIR = "rankdir/" + datasetSpec + ".csv"


# input, output are strings
def RankLookup(idx):
	global RANKDIR
	rank = dict()
	fd = open(RANKDIR, 'r')
	for key, val in csv.reader(fd):
		rank[key] = val
	return rank[idx]


def CopyFolder(srcDir, dstDir):
  if srcDir[-1] == '/':
	  srcDir = srcDir[0:-1]
  
  dstDir = dstDir + os.path.basename(srcDir) + '/'
  srcDir = srcDir + "/no_defense/"
  
  print('srcDir: ', srcDir)
  try:
      shutil.copytree(srcDir, dstDir)
  except OSError as exc: # python >2.5
	if exc.errno == errno.ENOTDIR:
		shutil.copy(srcDir, dstDir)
	else: 
		raise


# for crawling without rank info
# rank info is looked up from rankpath folder
def CopyFolderRankModified(srcDir, dstDir):
	print srcDir 

	if os.path.isdir(dstDir) == False:
		os.makedirs(dstDir)
	if srcDir[-1] == '/':
		srcDir = srcDir[0:-1]
  
	dstDir = dstDir + '/' + os.path.basename(srcDir) + '/'
	srcDir = srcDir + "/no_defense/"
	os.makedirs(dstDir);
	
	files = os.listdir(srcDir)
	for each_file in files:
		# get rank information
		ranks = RankLookup(each_file.split('-')[0])
		new_filename = str(ranks) + '-' + each_file.split('-')[1]
		#print('new_filename:', new_filename)
		shutil.copy(srcDir + each_file, dstDir + new_filename)

if __name__ == "__main__":
	files = os.listdir(Source)
	for each_file in files:
		if datasetSpec == 'all' or each_file == datasetSpec:
			fd = open(Source + each_file, 'r')
		
			for each_line in fd.readlines():
				each_line = each_line.strip()
				#print(each_line)
#				try:
				CopyFolderRankModified(each_line, Destination)
					#CopyFolder(each_line, Destination);
#				except:
#				print('Failed: ', each_line)
#					continue
