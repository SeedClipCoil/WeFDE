# FeatureMatrix.py
# 
# generate FeatureMatrix structure to feed the matlab scrips
# combine different instances of a crawl, and different crawls
# in a single file

import sys, os
import util

# DATAPATH is a list of paths to different crawls

RANK_START = 1500 


DATAPATH = list()
DATACRAWL = util.PathReader("TrafficAnalysis/celltrace/pathdir/non_monitor_1500-2000")



# generate DATAPATH
for each in DATACRAWL:
  DATAPATH.append(each + sys.argv[1] + "/")



DESTPATH = "TrafficAnalysis/attack/BayesMeasure_NEW/data/" + sys.argv[1] + "/"



def OutputFeature(filename, WHICH, datap):
  global DESTPATH, RANK_START 
  f = open(datap + filename, "r")
  
  if not os.path.isdir(DESTPATH):
    os.makedirs(DESTPATH)
  

  rank = str( int(WHICH) + RANK_START )

  g = open(DESTPATH + rank + '_train' + ".csv", "a")

  Line = f.readline()
  
  # rules to intercept
  for each_param in Line.split():
    if 'X' in each_param: 
      g.write('-1' + " ")
    else:
      g.write(each_param + " ")
  g.write("\n")

  g.close()
  f.close()
  
def FeatureHandler():
  global DATAPATH
  num = len(DATAPATH)
  for i in range(num):
    files = os.listdir(DATAPATH[i])
    counter = 0
    for each_file in files:
      # select feature
      if "feature" in each_file:
        # select index
        WHICH = each_file.split(".")[0].split("-")[0]
        counter = counter + 1
        OutputFeature(each_file, WHICH, DATAPATH[i])
  
def main():
  FeatureHandler()

if __name__ == "__main__":
  main()
