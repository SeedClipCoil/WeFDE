import os,sys,random 
import shutil


DatasetPath = "TrafficAnalysis/Dataset/DataMatrix/top2000/"
DestPath = "TrafficAnalysis/Dataset/DataMatrix/bootstrap/"

bootstrapNum = 20
randomNum = 100

def getFileList(dpath):
		
	flist = list() 
	for each_file in os.listdir(dpath):
		ext = each_file.split('.')[1]
		if ext == "csv":
			flist.append(each_file)
	
	return flist

def generateDataset(sample, bs):
	newFolder = DestPath + str(bs) + "/"
	if os.path.exists(newFolder):
		shutil.rmtree(newFolder)	
	os.makedirs(newFolder)
	
	for each_file in sample:
		srcpath = DatasetPath + each_file
		dstpath = newFolder + each_file
		os.symlink(srcpath, dstpath)
		

def getRandom(flist, n):
	return random.sample(flist, n)


def main():
	flist = getFileList(DatasetPath)
	
	for bs in range(20):
		sample = getRandom(flist, randomNum)
		generateDataset(sample, bs)	

if __name__ == "__main__":
	main()
