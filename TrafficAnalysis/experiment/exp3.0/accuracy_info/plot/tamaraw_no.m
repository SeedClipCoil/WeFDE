function [info, accuracy, prior_ent] = tamaraw_no()

info_path = '../info/';
accuracy_path = '../accuracy/';



%%%% construct tag list

tag = {};
count = 1;
for i = [10:10:100, 200:100:1000]
    tag{count} = strcat('tamaraw_no_obfuscate_', num2str(i));
    count = count + 1;
end


%%%% extract info leakage



for i = 1:length(tag)
    perinfo = zeros(1,51);
    for bstrap = 0:50
        % construct jobrecord and prior path
        jobrecord_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/JobRecord_', tag{i}, '_category1_top100_bstrap', num2str(bstrap), '.mat');
        prior_path = strcat(info_path, tag{i}, '/', 'combine_measure/jobrecord/prior.mat');
        
        prior_ent = GetPriorEnt(prior_path, 0);
        perinfo(bstrap+1) = JobRecordFusion(jobrecord_path, prior_ent);
    end
    info{i} = perinfo;
end




%%%% extract accuracy info

accuracy = [];

for i = 1:length(tag)
    % construct accuracy file name
    results_path = strcat(accuracy_path, tag{i}, '.results');
    acc = importdata(results_path);
    accuracy(i)= acc;
end




end
