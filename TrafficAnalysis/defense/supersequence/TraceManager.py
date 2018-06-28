from TraceGenerator import TraceGenerator
import os

class TraceManager:
  def __init__(self, sizes, times, webNum, instNum):
    self.sizes = sizes
    self.times = times
    self.webNum = webNum
    self.instNum = instNum


  def setGenerator(self, superSequenceList, cluster, stopPoints, method):
    self.cluster = cluster
    self.traceGeneratorList = list()
    for super_idx in range( len(superSequenceList) ):
      tg = TraceGenerator(method, superSequenceList[super_idx], stopPoints[super_idx])
      self.traceGeneratorList.append(tg)


  def setDstPath(self, dstPath):
    self.dstPath = dstPath
    if os.path.exists(dstPath) == False:
      os.makedirs(dstPath)


  def run(self, clusterTransmit):
    for i in range(self.webNum*self.instNum):
      web_idx = i/self.instNum
      inst_idx = i % self.instNum
      which_cluster = self.cluster[i]
      transmitCost = clusterTransmit[i]
      seq = self.traceGeneratorList[which_cluster].create(transmitCost)

      # output
      dst = self.dstPath + str(web_idx) + '-' + str(inst_idx)
      fd = open(dst, 'w')
      
      npack = len(seq[0])

      for i in range(npack):
        fd.write( str(seq[1][i]) + '\t' + str(seq[0][i]) + '\n')
      fd.close()

