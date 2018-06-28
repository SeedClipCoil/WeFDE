function [info, accuracy, prior_ent] = supersequence_4()

info_path = '../info/';
accuracy_path = '../accuracy/';



%%%% construct tag list

tag = {};
idx = 1;


% supersequence
% method 4
for i = [4:2:10, 20, 35, 50]
   tag{idx} = strcat('supersequence_method4supercluster2_clusternum', num2str(i), '_stoppoints4');
   idx = idx + 1;
end





%%%% extract info leakage


for i = 1:length(tag)
    for bstrap = 0:50
        % construct jobrecord and prior path
        jobrecord_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/JobRecord_', tag{i}, '_category1_top100_bstrap', num2str(bstrap), '.mat');
        prior_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/prior.mat');
   
        prior_ent = GetPriorEnt(prior_path, 1);
        perinfo(bstrap+1) = JobRecordFusion(jobrecord_path, prior_ent);
    end
    info{i} = perinfo;        
end



%%% extract accuracy info

accuracy = [];

for i = 1:length(tag)
    % construct accuracy file name
    results_path = strcat(accuracy_path, tag{i}, '.results');
    acc = importdata(results_path);
    accuracy(i)= acc;
end




end