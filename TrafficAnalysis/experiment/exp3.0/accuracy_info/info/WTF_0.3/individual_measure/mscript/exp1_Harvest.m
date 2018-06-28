% output array of individual feature's info leakage
clear;
addpath('../../../../../post-process/');
addpath('../../../../../../../attack/InfoMeasure/parallel_measure/')



tag = 'WTF_0.3'


idx = 1:3043;

data_path = '../jobrecord/';

iter = 1;

% collecting statistics

prior_ent = GetPriorEnt();

for i = idx
    for j = 1:iter
        jm_path = strcat(data_path, 'JobRecord_', tag, '_fidx', int2str(i), '_iter', num2str(j), '.mat')
        ent{j}(i) = JobRecordFusion(jm_path, prior_ent);
    end
end



% average

ave = ( ent{1} + ent{1} )/2;




save('../results/ave_entropy.mat', 'ave');
