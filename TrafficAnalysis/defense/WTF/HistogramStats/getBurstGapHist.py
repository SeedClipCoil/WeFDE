import os.path
import sys
sys.path.append('../')
import base 


# where is original trace?


DEBUG_ON = 0 




crawl_src = list()
crawl_src.append("Dataset/closed/crawl160208_194933/")
crawl_src.append("Dataset/closed/crawl160208_195035/")
crawl_src.append("Dataset/closed/crawl160208_195402/")
crawl_src.append("Dataset/closed/crawl160208_195321/")
#


### I should do in orp way. anyway...


####################################################
## something about InfoList ########################


def InstanceInfoList(path_list, direction):
    
    # a list of info(s) corresponding to each instance
    instanceInfoList = list()
    for path in path_list:
        for i in range(1,101):
            #print i
            for j in range(0,150):
                filename = path  + str(i) + "-" + str(j)
                if not (os.path.isfile(filename)):
                    continue
                else:
                    instanceInfoList.append( getInstanceInfo(filename, direction) )
    return instanceInfoList


## get average bandwidth
def getAveBandwidth(instanceInfoList):
    accum = 0.0
    num = 0.0
    for each_info in instanceInfoList:
        accum = accum + getBandwidth(each_info)
        num = num + 1

    return accum/num

def getAveM(instanceInfoList):
    accum = 0.0
    num = 0.0
    for each_info in instanceInfoList:
        gm = getMaxInterTime(each_info)
        if gm == None:
            continue
        accum = accum + gm 
        num = num + 1

    return accum/num


def getAveBurstLength(instanceInfoList, bThres):

    accum = 0.0
    num = 0.0
    for each_info in instanceInfoList:
        accum = accum + getBurstLength(each_info, bThres)
        num = num + 1
    return accum/num




def getAveBurstGapHist(instanceInfoList, thres, M, n):
    histScale = getHistogramScale(M, n);
    
    accumBurstHist = [0]*len(histScale)
    accumGapHist = [0]*len(histScale)
    counter = 0

    for each_info in instanceInfoList:
        bg = getBurstGapHist(each_info, thres, M, n)
        if bg == None:
            continue
        burstHist = bg[0]
        gapHist = bg[1]

        accumBurstHist = addHist(accumBurstHist, burstHist)
        accumGapHist = addHist(accumGapHist, gapHist)
        counter = counter + 1
    
    # get ave
    aveBurstHist = [x/counter for x in accumBurstHist]
    aveGapHist = [x/counter for x in accumGapHist]

    returnVal = list()
    returnVal.append(aveBurstHist)
    returnVal.append(aveGapHist)

    return returnVal


def addHist(hist1, hist2):
    if len(hist1) != len(hist2):
        raise ValueError("in addHist: dimension not match!")
    else:
        # add two hist
        nbin = len(hist1)
        res = [0]*nbin
        for i in range(0, nbin):
            res[i] = hist1[i] + hist2[i]
        return res


#######################################################
### something about info (a single instance)  ########



def histLocator(histScale, interTime):
    for i in range(0, len(histScale)):
        if interTime >= histScale[i][0] and interTime < histScale[i][1]:
            return i
    
    # if interTime >= M
    return None






def getBurstGapHist(info, thres, M, n):

    interTimeList = info[0]

    # gap and burst mode has the same histScale
    histScale = getHistogramScale(M, n);

    burstHist = [0]*len(histScale)
    gapHist = [0]*len(histScale)

    for interTime in interTimeList:
        # locate which bin..
        idx = histLocator(histScale, interTime)
        if idx == None:
            # if interTime exceeds M...
            continue
        if interTime > thres:
            # in burst mode
            burstHist[idx] = burstHist[idx] + 1
        else:
            # in gap mode
            gapHist[idx] = gapHist[idx] + 1

   
    bsum = float( sum(burstHist) )
    gsum = float( sum(gapHist) )

    if bsum == 0 or gsum == 0:
        return None


    if DEBUG_ON:
        print "burstHist:", burstHist
        print "gapHist:", gapHist
        print "interTimeList:", info[0]
        print "histScale:", histScale

    burstProbability = [x/bsum for x in burstHist]
    gapProbability = [x/gsum for x in gapHist]

    returnVal = list()
    returnVal.append(burstProbability)
    returnVal.append(gapProbability)



    return returnVal



def getMaxInterTime(info):
    try:
        return max( info[0] )
    except ValueError:
        return None 

def getBandwidth(info):
    difference = info[1][1] - info[1][0]
    totalNum = len(info[0]) + 1
    bandwidth = difference/totalNum
    return bandwidth


def getBurstLength(info, thres):
    interTimeList = info[0]
    
    burstLen = list()

    l = 0
    for idx in range( len(interTimeList) ):
        if interTimeList[idx] < thres:
            # burst not ended
            l = l + 1
        else:
            # burst ends
            burstLen.append(l+1)
            l = 0

    # take care of last burst
    burstLen.append(l+1)


    # debug 
#    print "interTimeList:", interTimeList
#    print "burstLen:", burstLen



    return sum(burstLen)/float( len(burstLen) )




# get inter time list from a instance (by filename)
def getInstanceInfo(filename, direction):
    
    try:
        with open(filename, 'r') as fd:

            i =0
            pre = 0.0
            post = 0.0

            InterTimeList = []
            
            for line in fd:

                d = getSign(line)
                #   check direction
                if (d == direction):
                    if (i != 0):
                        post = getTime(line)
                        interval = post - pre
                        InterTimeList.append(interval)
                        pre = post
                    #init traffic
                    if (i == 0):
                        pre = getTime(line)
                        init = pre

                    i = i + 1

            fd.close()

            info = list()
            # 1st: the inter-time list
            # 2nd: the beginning and ending timestamp
            # 3rd: filename
            info.append(InterTimeList)
            info.append([init, post])
            info.append(filename)

            return info

    except IOError:
        print(filename + " does not exist") 


# get sign, time, or size from a record
def getSign(line):
    size = getSize(line)
    if size < 0:
        direct = -1
    else:
        direct = 1
    return direct

def getTime(line):
    time = float( line.split()[0] )
    return time

def getSize(line):
    size = float( line.split()[1] )
    return size





### histogram: bins 


#resultlist = [[0, M/(2**(n-2))], [,].....[M/2,M]]
# includes I_1, but excludes I_n which is the infinite bin
def getHistogramScale(M, n):
    # convert to float 
    M = float(M)

    resultList = [] 
    a = 0 
    #a = M/(2**(n-i))
    #b = M/(2**(n-i-1))

    #set the scale according to M, n 
    for i in range(2, n+1):
        tempList = []
        tempList.append(a)
        a = M/(2**(n-i))
        tempList.append(a)
        resultList.append(tempList)

    return resultList



def addInfinityBin(bgHist, aveBurstLength, BURST_PROB):
    bHist = bgHist[0]
    gHist = bgHist[1]
    
    # total token number for non-infinity bins
    K = 10000
    # fall in Burst's infinity bin: probability of NOT faking bursts
    Pn = 1 - BURST_PROB
    
    bToken = [int(x*K) for x in bHist]
    gToken = [int(x*K) for x in gHist]

    if DEBUG_ON:
        print "bgHist:", bgHist
        print "bToken:", bToken
        print "gToken:", gToken

    # add infinity bin to Burst
    bkn = Pn/(1-Pn)*K
    bToken.append( int(bkn) )


    # add infinity bin to Gap
    gkn = (K-aveBurstLength+1)/(aveBurstLength-1)
    gToken.append( int(gkn) )

    # return in token

    returnVal = list()
    returnVal.append(bToken)
    returnVal.append(gToken)

    return returnVal
    

# generate the histogram
# endpoint:     "client" or "server"
# mode:         "burst" or "gap"
def generateBGHist(endpoint):
    global crawl_src
    if endpoint == "client":
        instanceInfoList = InstanceInfoList(crawl_src, 1)
    elif endpoint == "server":
        instanceInfoList = InstanceInfoList(crawl_src, -1)

    n = base.NUM_BINS 

    bandwidth_threshold = getAveBandwidth(instanceInfoList)
    print "bandwidth_threshold:", bandwidth_threshold

    ave_burst = getAveBurstLength(instanceInfoList, bandwidth_threshold)
    print "ave_burst:", ave_burst

#    M = getAveM(instanceInfoList)
#    print "ave_M:", M

    M = base.MAX_IAT
    # get two Histgrams
    bgHist = getAveBurstGapHist(instanceInfoList, bandwidth_threshold, M, n)
    if DEBUG_ON:
        print bgHist

    return [bgHist, ave_burst]

# generate the histogram
# endpoint:     "client" or "server"
# mode:         "burst" or "gap"
def generateHistogram(bgHist, ave_burst, burst_prob):

    # add infinity bins...
    final = addInfinityBin(bgHist, ave_burst, burst_prob)
    return final


    
def main():
    # take in the probability of faking a burst
    probList = [float(x)/10 for x in range(1,10)]
        
    print "computing client..."
    returnVal_client = generateBGHist("client")
        
    print "computing server..."
    returnVal_server = generateBGHist("server")

    for burst_prob in probList:

        fd = open("bglist_" + str(burst_prob) + ".txt", 'w')

        bgToken_client = generateHistogram(returnVal_client[0], returnVal_client[1], burst_prob)
        bgToken_server = generateHistogram(returnVal_server[0], returnVal_server[1], burst_prob)
    
        for i in range(0,2):
            # client
            for tk in bgToken_client[i]:
                fd.write(str(tk) + " ")
            fd.write("\n")
    
            # server
            for tk in bgToken_server[i]:
                fd.write(str(tk) + " ")
            fd.write("\n")
    
        fd.close()
    
if __name__ == "__main__":
    main()
