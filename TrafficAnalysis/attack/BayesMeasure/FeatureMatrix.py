# FeatureMatrix.py
# 
# generate FeatureMatrix structure to feed the matlab scrips
# combine different instances of a crawl, and different crawls
# in a single file

import sys, os


# DATAPATH is a list of paths to different crawls




DATAPATH = list()
DATACRAWL = list()



## closed world ########################
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/feb8/0/crawl160208_194933/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/feb8/1/crawl160208_195035/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/feb8/2/crawl160208_195402/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/feb8/3/crawl160208_195321/")

#### the open world, monitored #################

DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/1/crawl160502_122335/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/1/crawl160503_085238/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/2/crawl160502_122542/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/2/crawl160503_085630/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/3/crawl160502_122726/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/3/crawl160503_085436/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/4/crawl160502_122905/")
DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/4/crawl160503_085840/")




### the open world, non-monitored  #########################


#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/1/crawl160310_170708/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/1/crawl160321_112645/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/1/crawl160331_131728/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/1/crawl160410_163402/")



#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/2/crawl160310_171021/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/2/crawl160321_112950/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/2/crawl160331_130328/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/2/crawl160410_163603/")



#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/3/crawl160310_171413/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/3/crawl160321_113220/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/3/crawl160310_171413/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/3/crawl160410_163755/")


#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/4/crawl160310_171726/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/4/crawl160321_113359/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/4/crawl160331_130942/")
#DATACRAWL.append("/media/WD500/Research/TrafficAnalysis/March4/4/crawl160410_164526/")





# end ######################################



# generate DATAPATH
for each in DATACRAWL:
  DATAPATH.append(each + sys.argv[1] + "/")



DESTPATH = "TrafficAnalysis/attack/BayesMeasure_NEW/dataset_open_world/monitored/" + sys.argv[1] + "/"




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
  
def FeatureHandler(WHICH):
  global DATAPATH
  num = len(DATAPATH)
  for i in range(num):
    files = os.listdir(DATAPATH[i])
    counter = 0
    for each_file in files:
      # select feature
      if "feature" in each_file:
        # select index
        if each_file.split(".")[0].split("-")[0] == WHICH:
          counter = counter + 1
          OutputFeature(each_file, WHICH, DATAPATH[i])
  
def main():
  for i in range(1000):
    FeatureHandler(str(i))

if __name__ == "__main__":
  main()
