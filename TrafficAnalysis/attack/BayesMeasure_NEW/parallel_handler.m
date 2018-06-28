c = parcluster();
t = tempname();
mkdir(t);
c.JobStorageLocation=t;
parpool(c);
