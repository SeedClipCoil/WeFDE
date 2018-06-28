%function results = solo(tag)
function info = wtf_combine(exp_tag, world_size, bstrap_idx)

RESULT_PATH = strcat('./debug_data/', world_size, '-', exp_tag, '_bstrap', num2str(bstrap_idx), '.mat');

home_directory = readParam('home_directory', 1)



% import MIanalysis results for exp_tag
MIanalysis_path = strcat(home_directory, 'experiment/exp3.0/accuracy_info/info/', exp_tag, '/combine_measure/MIanalysis/MIanalysis_cat1_topn100.mat');
m = importdata(MIanalysis_path);
vec = m.vec;






Dataset_path = strcat('TrafficAnalysis/Dataset/DataMatrix/');
monitor_dataset = strcat(Dataset_path, world_size, '-', exp_tag, '/');
argMap = containers.Map();
argMap('monitor_dataset') = monitor_dataset;
argMap('prior_filename') = strcat(world_size, '-', exp_tag, '_prior.mat');

% build the model
if bstrap_idx == 0
    % no bootstrap
    info = model_init(vec, 0, 0, argMap);
else
    info = model_init(vec, 1, 0, argMap);
end



webNum = length(info.WebsiteList);


parfor i = 1:webNum
  temp = info.Evaluate(i, []);
  res{i} = temp{i};
end


results.JobResults = res;

save(RESULT_PATH, 'results');


end
