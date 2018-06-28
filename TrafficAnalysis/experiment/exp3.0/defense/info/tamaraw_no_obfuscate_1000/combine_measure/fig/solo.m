addpath('../../../../../post-process/');
addpath('../../../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../../../attack/MIanalysis/');


tag = [2000,1000,500];
res = [];

for i = 1:length(tag)
  jr = strcat('../jobrecord/top', num2str(tag(i)), '-tamaraw_no_obfuscate_1000_bstrap0.mat');
  p = strcat('../jobrecord/top', num2str(tag(i)), '-tamaraw_no_obfuscate_1000_prior.mat');
  prior_ent = GetPriorEnt(p);

  res(i) = JobRecordFusion(jr, prior_ent);


end

plot(tag, res)

axis([0 3000 0 6])
