function [info, accuracy, prior_ent] = cs_buflo()

info_path = '../info/';
accuracy_path = '../accuracy/';



%%%% construct tag list

tag = {'cs_buflo'};




%%%% extract info leakage



for i = 1:length(tag)
    perinfo = zeros(1, 51);
    for bstrap = 0:49
        % construct jobrecord and prior path
        jobrecord_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/', tag{i}, '_category1_topn100_bstrap', num2str(bstrap), '.mat')
        prior_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/prior.mat');
   
        prior_ent = GetPriorEnt(prior_path, 0);
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