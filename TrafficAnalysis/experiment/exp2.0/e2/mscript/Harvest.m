function Harvest(n)


% experiment 1
addpath('../../post-process/');
addpath('../../../../attack/InfoMeasure/parallel_measure/');
%idx = 1:3043;
idx = n;
data_path = '../record/';


% collecting statistics
ave = zeros(1, length(idx));

prior_ent = GetPriorEnt();

for i = idx
	jm = strcat(data_path, 'JobRecord', '_', int2str(i), '.mat')
    jm_temp = importdata(jm);
    ave(1) = JobManagerFusion(jm_temp.JobResults, prior_ent);
    clear jm_temp;
end


path = strcat('../results/entropy_top', num2str(idx), '.mat');

save(path, 'ave');
