% 

function [info_leak, max_leak] = plot_wtf()

world_size = [500,1000,2000];





counter = 1;



for each_size = world_size
    prior_path = strcat('../info/WTF_0.9/combine_measure/jobrecord/top', num2str(each_size), '-WTF_0.9_prior.mat');
    result_path = strcat('../info/WTF_0.9/combine_measure/jobrecord/top', num2str(each_size), '-WTF_0.9_bstrap0.mat');
    prior_ent = GetPriorEnt(prior_path, 1);
    
    info_leak(counter) = JobRecordFusion(result_path, prior_ent);
    max_leak(counter) = prior_ent;
    counter = counter + 1;
end










end
