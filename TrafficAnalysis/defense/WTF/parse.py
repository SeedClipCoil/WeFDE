import os
import sys

from base import *

# 
def get_trace(path):
  pkt_list = list()
  fd = open(path, 'r')
  for line in fd:
    
    if len(pkt_list) == 0:
		# first line, extract startTime
		startTime = float(line.split()[0])
    # generate a Packet object
    timestamp = float(line.split()[0]) - startTime
    pkt_len = line.split()[1]
    pkt = Packet(str(timestamp), pkt_len)

    # append to pkt_list
    pkt_list.append(pkt)

  fd.close()
  return Trace(path, pkt_list)



def dump_tuple_list(tuple_list, dst_path):
  fd = open(dst_path, 'w')
  for timestamp, pkt_len, isDummy in tuple_list:
#    fd.write( str(timestamp) + str(pkt_len) + str(isDummy) )
    fd.write( str(timestamp) + "\t" + str(pkt_len) + '\n')

  fd.close()

  

def mkrow(timestamp, pkt_len):
  return str(timestamp) + "\t" + str(pkt_len)
  

