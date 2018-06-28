function parallel_handler(ncore)
c = parcluster();
tm = tempname();
t = strcat('/export/scratch/lixx2381', tm);
mkdir(t);
c.JobStorageLocation=t;

if nargin == 1
	c.NumWorkers = ncore;
	parpool(c, c.NumWorkers);
else
	parpool(c);
end

end


