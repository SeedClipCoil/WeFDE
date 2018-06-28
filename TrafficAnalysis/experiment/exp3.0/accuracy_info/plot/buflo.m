function [info, accuracy, prior_ent] = buflo()

info_path = '../info/';
accuracy_path = '../accuracy/';



%%%% construct tag list

tag = {};

icol = [1, 2:2:12, 16, 20, 24];
for i = 1:length(icol)
    tag{i} = strcat('buflo_', num2str( icol(i)*5 ) );
end


%%%% extract info leakage



for i = 1:length(tag)
    
    perinfo = zeros(1, 51);
    for bstrap = 0:50
        % construct jobrecord and prior path
        jobrecord_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/JobRecord_', tag{i}, '_category1_topn100_bstrap', num2str(bstrap), '.mat');
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