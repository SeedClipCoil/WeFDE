% experiment 1
addpath('../../../../post-process/');
addpath('../../../../../../attack/InfoMeasure/parallel_measure/')
idx = 1:3043;

data_path = '../jobrecord/record4/';


% collecting statistics
ave = zeros(1, length(idx));

prior_ent = GetPriorEnt();

for i = idx
	jm_path = strcat(data_path, 'JobRecord', '_', int2str(i), '.mat');
    ave(i) = JobRecordFusion(jm_path, prior_ent);
    clear jm_temp;
end



save('entropy4.mat', 'ave');