import sys, os
import matplotlib.pyplot as plt



CelltracePath = "TrafficAnalysis/Celltrace/trace/"

# given result path
# enumerate all the pcap files
def Enumerate(Dir):
  FileList = []
  for dirname, dirnames, filenames in os.walk(Dir):
    # skip logs directory
    if "logs" in dirnames:
      dirnames.remove("logs")
    # if file exists
    if len(filenames) != 0:
      for filename in filenames:
        fulldir = os.path.join(dirname, filename)
        FileList.append(fulldir)
  return FileList




def plot(File):
  fd = open(File, "r")
  
  time = list()
  cellnum = list()
  
  for each_line in fd.readlines():
    
    stime = each_line.strip().split(",")[0]
    scellnum = each_line.strip().split(",")[1]
    time.append(float(stime))
    cellnum.append(int(scellnum))
  
  plt.plot(time,cellnum, "ro")
  plt.axis([0,4,-10,10])
  #plt.show()
  filename = os.path.basename(File)
  plt.savefig(filename + ".eps")
  

def main():
  FileList = Enumerate(CelltracePath)
  for index, each_file in enumerate(FileList):
    if index < 2 or 1:
      print each_file
      plot(each_file)

if __name__ == "__main__":
  main()
