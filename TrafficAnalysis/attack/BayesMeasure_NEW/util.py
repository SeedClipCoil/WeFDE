def PathReader(filename):
  f = open(filename, 'r')
  crawl = list()
  for each_line in f.readlines():
    crawl.append(each_line.strip('\n'))
  return crawl
