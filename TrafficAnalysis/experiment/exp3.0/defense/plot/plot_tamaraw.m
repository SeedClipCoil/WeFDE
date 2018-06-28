% 

function [info_leak, max_leak] = plot_tamaraw()

world_size = [500,1000,2000];





counter = 1;

for tamaraw = [100, 500, 1000]
    
    for each_size = world_size
        prior_path = strcat('../info/tamaraw_no_obfuscate_', num2str(tamaraw), '/combine_measure/jobrecord/top', num2str(each_size), '-tamaraw_no_obfuscate_', num2str(tamaraw), '_prior.mat');
        result_path = strcat('../info/tamaraw_no_obfuscate_', num2str(tamaraw), '/combine_measure/jobrecord/top', num2str(each_size), '-tamaraw_no_obfuscate_', num2str(tamaraw), '_bstrap0.mat');

        if tamaraw == 1000
            prior_ent = GetPriorEnt(prior_path, 0);
        else
            prior_ent = GetPriorEnt(prior_path, 1);
        end
        info_leak(counter) = JobRecordFusion(result_path, prior_ent);
        max_leak(counter) = prior_ent;
        counter = counter + 1;     
    end


end







end
