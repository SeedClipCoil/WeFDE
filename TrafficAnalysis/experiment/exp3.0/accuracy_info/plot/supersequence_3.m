function [info, accuracy, prior_ent] = supersequence_3()

info_path = '../info/';
accuracy_path = '../accuracy/';



%%%% construct tag list

tag = {};
idx = 1;


% supersequence


for super = [2,5,10]
    for stop = [4,8,12]
        tag{idx} = strcat('supersequence_method3supercluster', num2str(super), '_clusternum20_stoppoints', num2str(stop));
        idx = idx  + 1;
    end
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