from TCPtraceGenerator import TCPtraceGenerator
import os, sys, shutil
import util

# for each batch, how many instances
NUM_INSTANCE = 30 

CrawlPath = util.PathReader("TrafficAnalysis/celltrace/pathdir/closed")

#CrawlPath.append("")






ResultPath = "" 
CelltracePath = ""





# given result path
# enumerate all the pcap files
def Enumerate(Dir):
  FileList = []
  for dirname, dirnames, filenames in os.walk(Dir):
    # skip logs directory
    if "logs" in dirnames:
      dirnames.remove("logs")
    if "no_defense" in dirnames:
      dirnames.remove("no_defense")
    # if file exists
    if len(filenames) != 0:
      for filename in filenames:
        # exclude *.png 
        if "png" not in filename:
          fulldir = os.path.join(dirname, filename)
          FileList.append(fulldir)
  return FileList



# create file following Wang's folder layout
def CreateFile2(DirFile):
  global ResultPath
  global CelltracePath
  global NUM_INSTANCE
  Filename = os.path.basename(DirFile)
  
  print Filename
  batch = Filename.split("_")[0]
  webnum = Filename.split("_")[1]
  visitnum = Filename.split("_")[2].split(".")[0]
  
  NewName = webnum + "-" + str( int(batch)*NUM_INSTANCE + int(visitnum) )
  DestPath = os.path.join(CelltracePath, NewName)
  
  fd = open(DestPath, "w+")
  fd.close()
  return DestPath

# given the address of the source pcap
# create a celltrace file in corresponding folder
# return the path of the created file

# folder layout is same as the pcap folder
def CreateFile1(DirFile):
  global ResultPath
  global CelltracePath

  Filename = os.path.basename(DirFile)
  AbsPath = os.path.dirname(DirFile)
  RelPath = os.path.relpath(AbsPath, ResultPath)

  NewName = Filename.split(".")[0] + ".txt"
  DestPath = os.path.join(CelltracePath, RelPath, NewName)  
  
  # create folder if nonexist
  DestDir = os.path.dirname(DestPath)
  if not os.path.exists(DestDir):
    os.makedirs(DestDir)

  fd = open(DestPath, "w+")
  fd.close()
  return DestPath



# check if the visit was successful
# by looking at the snapshot
def IsSuccess(pcap):
  # path to the snapshot
  screen = os.path.dirname(pcap) + '/screenshot.png'
  # check size of the snapshot
  if os.path.isfile(screen) == False:
    # no screenshot, check pcap size
    size = os.path.getsize(pcap)
    if size < 100000:
      print "pcap size:", size
      return False
    else:
      return True
  else:
    # screenshot exists, check it
    size = os.path.getsize(screen)
    if size > 5000:
      return True  
    else:
      print "screenshot size:", size
      return False

def main():
  global ResultPath, CelltracePath

  # if CelltracePath exists
  if not os.path.isdir(CelltracePath):
    os.makedirs(CelltracePath)
  PcapAll = Enumerate(ResultPath)
  for each_pcap in PcapAll:
    print "each_pcap is: ", each_pcap

    # check if the visit is successful
    # inspect the snapshot
    try:
      success = IsSuccess(each_pcap)
    except OSError:
      continue
    if success == False:
      print "[Fail] ", each_pcap
      f = open('snapshot_blank', 'a')
      f.write(each_pcap + "\n")
      f.close()
      continue
    try:
      DestPath = CreateFile2(each_pcap)
    except IndexError:
      continue 
    Generator = TCPtraceGenerator(each_pcap, DestPath)
    Generator.Generate()

if __name__ == "__main__":
  for each_path in CrawlPath:
    ResultPath = each_path 
    CelltracePath = each_path + "no_defense/" 
    main()
