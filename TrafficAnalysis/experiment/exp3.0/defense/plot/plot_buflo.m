% 

function [info_leak, max_leak] = plot_buflo()

world_size = [500,1000,2000];





counter = 1;

for buflo = [20, 60, 120]
    
    for each_size = world_size
        prior_path = strcat('../info/buflo_', num2str(buflo), '/combine_measure/jobrecord/top', num2str(each_size), '-buflo_', num2str(buflo), '_prior.mat');
        result_path = strcat('../info/buflo_', num2str(buflo), '/combine_measure/jobrecord/top', num2str(each_size), '-buflo_', num2str(buflo), '_bstrap0.mat');
        prior_ent = GetPriorEnt(prior_path, 1);
      
        info_leak(counter) = JobRecordFusion(result_path, prior_ent);
        max_leak(counter) = prior_ent;
        counter = counter + 1;     
    end


end







end
