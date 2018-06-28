# FeatureMatrix.py
# 
# generate FeatureMatrix structure to feed the matlab scrips
# combine different instances of a crawl, and different crawls
# in a single file




import sys, os


import util


# DATAPATH is a list of paths to different crawls




#keyword = sys.argv[1]



#DATAPATH = util.PathReader(keyword)
DATAPATH = list()
#DATAPATH.append("TrafficAnalysis/defense/buflo/pattern/results/" + sys.argv[1] + "/")


# defenses
DATAPATH.append("TrafficAnalysis/attack/KNN/Dataset/defenses/" + sys.argv[1] + "/")
DESTPATH = "TrafficAnalysis/attack/KNN/Dataset/DataMatrix/" + sys.argv[1] + "/"

# enlarge defense
#DATAPATH.append("TrafficAnalysis/Dataset/defense/" + sys.argv[1] + "/" + sys.argv[2] + "/")
#DESTPATH = "TrafficAnalysis/Dataset/DataMatrix/" + sys.argv[1] + "-" + sys.argv[2] + "/"

# closed world 
#DATAPATH.append("TrafficAnalysis/Dataset/closed/" + sys.argv[1] + "/")
#DESTPATH = "TrafficAnalysis/Dataset/DataMatrix/" + sys.argv[1] + "/"


#DESTPATH = "TrafficAnalysis/attack/InfoMeasure/DataMatrix/" + sys.argv[1] + "/"
#DESTPATH = "TrafficAnalysis/defense/buflo/pattern/final/" + sys.argv[1] + "/"



def OutputFeature(filename, WHICH, datap):
  global DESTPATH 
  f = open(datap + filename, "r")
  
  if not os.path.isdir(DESTPATH):
    os.makedirs(DESTPATH)
  


  g = open(DESTPATH + WHICH + '_train' + ".csv", "a")

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
