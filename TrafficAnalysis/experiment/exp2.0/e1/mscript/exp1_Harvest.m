% experiment 1
addpath('../../post-process/');
addpath('../../../../attack/InfoMeasure/parallel_measure/')
idx = 1:3043;

data_path = '../record4/';


% collecting statistics
ave = zeros(1, length(idx));

prior_ent = GetPriorEnt();

for i = idx
	jm = strcat(data_path, 'JobRecord', '_', int2str(i), '.mat')
    jm_temp = importdata(jm);
    ave(i) = JobManagerFusion(jm_temp.JobResults, prior_ent);
    clear jm_temp;
end



save('../results/entropy4.mat', 'ave');