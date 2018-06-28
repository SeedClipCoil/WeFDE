function [lower, upper] = AccInterval(acc)
%function trial_collect = AccInterval(acc)

trial_num = 100;
inst_num = 9400;

trial_collect = [];
for each_trial = 1:trial_num
    temp_right = 0;
    for each_inst = 1:9400
        if rand < acc
            % correct decision
            temp_right = temp_right + 1;
        end
    end
    
    trial_collect(each_trial) = temp_right/inst_num;
end



% 96% confidence interval

ss = sort(trial_collect);

upper = ss(98);
lower = ss(3);
end