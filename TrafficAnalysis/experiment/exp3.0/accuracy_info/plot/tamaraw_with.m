function [info, accuracy] = tamaraw_with()


experiment_path = '../info/';
accuracy_path = '../accuracy/';

tag = {};
count = 1;
for i = [10:10:100, 200:100:1000]
    tag{count} = strcat('tamaraw_with_obfuscate_', num2str(i));
    count = count + 1;
end


info = [];

for i = 1:length(tag)
    % construct jobrecord and prior path
    jobrecord_path = strcat(experiment_path, tag{i}, '/', 'combine_measure/jobrecord/JobRecord.mat');
    prior_path = strcat(experiment_path, tag{i}, '/', 'combine_measure/jobrecord/prior.mat');
   
    prior_ent = GetPriorEnt(prior_path, 0);
    info(i) = JobRecordFusion(jobrecord_path, prior_ent);
    
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
