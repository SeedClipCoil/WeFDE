import os, sys
import subprocess


MY_ADDR = "10.0.2.15"


class CelltraceGenerator():

  def __init__(self, fdir, ddir):
    self.FileDir = fdir
    self.DestFile = ddir

  def Generate(self):
    ports = self.PortsExtract()
    
    proc = subprocess.Popen(["tshark", "-T", "fields", "-o", "http.ssl.port:" + ports, "-e", "frame.time_relative", "-e", "frame.len", "-e", "ip.src", "-e", "tcp.srcport", "-e", "ssl.record.length", "-E", "header=y", "-E", "separator=,", "-r", self.FileDir], stdout=subprocess.PIPE)
    Lines = proc.stdout.readlines()
    NewLines = self.Rule(Lines)

    # write to files
    fd = open(self.DestFile, "w")
    for each_line in NewLines: 
      fd.write(each_line)
    fd.close()



  # let the port number to be TLS
  def PortsExtract(self):
    proc = subprocess.Popen(["tshark", "-T", "fields", "-e", "tcp.srcport", "-E", "separator=,", "-r", self.FileDir], stdout=subprocess.PIPE)
    Lines = proc.stdout.readlines()
    ports = list()
    for each_line in Lines:
      line = each_line.strip()
      if line not in ports:
        ports.append(line)
    
    # check length of the ports
#    if len(ports) > 2:
#      print "Error: a communication has bigger than 2 ports!"
     
    return ",".join(ports)






  # rule to process the tcp trace line
  def Rule(self, Lines):
    global MY_ADDR
    NewLines = list()
    for each_line in Lines:
      
      # ignore depict line
      if "ip.src" in each_line:
        continue

      fields = FieldLocator(each_line)
      # ssl length exists
      if fields.SllLength() != 0:
        
        time = fields.Time()
        SrcAddr = fields.SrcAddress()
        
        # send
        if SrcAddr == MY_ADDR:
          flag = ""
        else:
          flag = "-"
        ncell = fields.SllLength()/500
        new_line = ""
        for n in range(ncell):
          new_line = new_line + time + "\t" + flag + "1" + "\n"
        NewLines.append(new_line)
    return NewLines



class FieldLocator():
  
  def __init__(self, Line):
    self.line = Line.strip()

  def Time(self):
    return self.line.split(",")[0]

  def FrameLength(self):
    return self.line.split(",")[1]

  def SrcAddress(self):
    return self.line.split(",")[2]

  def SrcPort(self):
    return self.line.split(",")[3]

  def SllLength(self):
    fields = self.line.split(",")
    # no ssl length
    if fields[4] == "":
      return 0 
    # multiple ssl length
    elif len(fields) > 5: 
      counter = 0
      for each_len in fields[4:]:
        counter = counter + int(each_len)
      return counter

    # single ssl length
    else:
      return int(self.line.split(",")[4])
