#Generates 1-X from 0-X.
import math
import random
import multiprocessing

def fsign(num):
    if num > 0:
        return 0
    else:
        return 1

def defend(list1, list2, parameter):
    datasize = 1
    # configure (s)
    mintime = int( sys.argv[1] )
    #mintime = 10
    
    buf = [0, 0]
    listind = 0 #marks the next packet to send
    starttime = list1[0][0]
    lastpostime = starttime
    lastnegtime = starttime
    curtime = starttime
    count = [0, 0]
    lastind = [0, 0]
    for i in range(0, len(list1)):
        if (list1[i][1] > 0):
            lastind[0] = i
        else:
            lastind[1] = i
    defintertime = [[0.02], [0.02]]
    while (listind < len(list1) or buf[0] + buf[1] > 0 or curtime < starttime + mintime):
        #print "Send packet, buffers", buf[0], buf[1], "listind", listind
        #decide which packet to send

        # if one direction packets end, and curtime is larger than threshold, then end that direction with the other direction continue to transmit in constant interval

        if (curtime >= starttime + mintime):
            for j in range(0, 2):
                if (listind > lastind[j]):
                    defintertime[j][0] = 10000     
        ind = int((curtime - starttime) * 10)
        if ind >= len(defintertime[0]):
            ind = len(defintertime[0])//2  #?????
        if lastpostime + defintertime[0][ind] < lastnegtime + defintertime[1][ind]:
            cursign = 0
            curtime = lastpostime + defintertime[0][ind]
            lastpostime += defintertime[0][ind]
        else:
            cursign = 1
            curtime = lastnegtime + defintertime[1][ind]
            lastnegtime += defintertime[1][ind]
##            print "Sending packet sign", cursign, "Time", curtime, "defintertime", defintertime
##            print "Lastind", lastind
        #check if there's data remaining to be sent

        # tosend: a packet ship describing the room left
        # if a packet is larger than the room left, buf contains the remains util next ship comes to clear the buf. 
        tosend = datasize
        if (buf[cursign] > 0):
            if buf[cursign] <= datasize:
                tosend -= buf[cursign]
                buf[cursign] = 0
                listind += 1
            else:
                tosend = 0
                buf[cursign] -= datasize
        if (listind < len(list1)):
            while (list1[listind][0] <= curtime and fsign(list1[listind][1]) == cursign and tosend > 0):
                if (tosend >= abs(list1[listind][1])):
                    tosend -= abs(list1[listind][1])
                    listind += 1
                else:
                    buf[cursign] = abs(list1[listind][1]) - tosend
                    tosend = 0
                if (listind >= len(list1)):
                    break
        if cursign == 0:
            list2.append([curtime, datasize])
        else:
            list2.append([curtime, -datasize])
        count[cursign] += 1
        #print count, listind
        
import sys
import os





# src pathes to consider
crawl_src = list()
# closed and open world
crawl_src.append("TrafficAnalysis/Dataset/closed/top100/")
crawl_src.append("TrafficAnalysis/Dataset/openworld/non_monitor_0-500/")
crawl_src.append("TrafficAnalysis/Dataset/openworld/non_monitor_500-1500/")
crawl_src.append("TrafficAnalysis/Dataset/openworld/non_monitor_1500-2000/")

#crawl_src.append("TrafficAnalysis/defense/buflo/pattern/template/")
#crawl_src.append("TrafficAnalysis/attack/KNN/Dataset/no_defense/")


#crawl_src.append("Dataset/closed/crawl160208_194933/")
#crawl_src.append("Dataset/closed/crawl160208_195035/")
#crawl_src.append("Dataset/closed/crawl160208_195402/")
#crawl_src.append("Dataset/closed/crawl160208_195321/")


# dst pathes to hold the results
crawl_dst = list()

crawl_dst.append("TrafficAnalysis/Dataset/closew_defense/top100/buflo_" + sys.argv[1] + "/")

#open world
crawl_dst.append("TrafficAnalysis/Dataset/openw_defense/non_monitor_0-500/buflo_" + sys.argv[1] + "/")
crawl_dst.append("TrafficAnalysis/Dataset/openw_defense/non_monitor_500-1500/buflo_" + sys.argv[1] + "/")
crawl_dst.append("TrafficAnalysis/Dataset/openw_defense/non_monitor_1500-2000/buflo_" + sys.argv[1] + "/")

#crawl_dst.append("TrafficAnalysis/defense/buflo/pattern/results/buflo_" + sys.argv[1] + "/")
#crawl_dst.append("Dataset/defense/buflo/crawl160208_194933/")
#crawl_dst.append("Dataset/defense/buflo/crawl160208_195035/")
#crawl_dst.append("Dataset/defense/buflo/crawl160208_195402/")
#crawl_dst.append("Dataset/defense/buflo/crawl160208_195321/")





parameters = [0, 1500, 0.02, 10]
    
s_sitenum = 0
e_sitenum = 2500 
instnum = 400 


def main(fold_src, fold_dst):
  global s_sitenum, e_sitenum, instnum
  
  if not os.path.exists(fold_dst):
    os.makedirs(fold_dst)


  for j in range(s_sitenum, e_sitenum):
#      print (j)
      for i in range(0, instnum):
          packets = []
          if (os.path.isfile(fold_src + str(j) + "-" + str(i))):
            f = open(fold_src + str(j) + "-" + str(i), "r")
            d =  open(fold_dst + str(j) + "-" + str(i), "w")
            try:
                lines = f.readlines()
                starttime = float( lines[0].split('\t')[0] )
                for x in lines:
                    x = x.split("\t")
                    packets.append([float(x[0]) - starttime, int(x[1])])

                list2 = []
                defend(packets, list2, parameters)
                list2 = sorted(list2, key = lambda list2: list2[0])
                for x in list2:
                    d.write(repr(x[0]) + "\t" + repr(x[1]) + "\n")
            except:
                f.close()
                d.close()
                print "skip:", j, "-", i
                continue

            f.close()
            d.close()


if __name__ == "__main__":
  pjobs = []
  for i in range(len(crawl_src)):
    src = crawl_src[i]
    dst = crawl_dst[i]
    p = multiprocessing.Process(target=main, args=(src, dst,))
    pjobs.append(p)
    p.start()
  
  for eachp in pjobs:
      eachp.join()
