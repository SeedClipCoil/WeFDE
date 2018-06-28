import os

DST_PATH = "TrafficAnalysis/experiment/exp3.0/accuracy_info/accuracy/"



def main():
  for each_file in os.listdir('.'):
    if "results" not in each_file:
      continue
    fd = open(each_file, 'r')
    lines = fd.readlines()
    last = lines[-1] 
    acc = last.split(": ")[1]
    print each_file, acc
    dd = open(DST_PATH + each_file, 'w')
    dd.write(acc)
    dd.close()
    fd.close()












if __name__ == "__main__":
  main()
