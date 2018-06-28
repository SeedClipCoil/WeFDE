%function results = solo(tag)
function info = tamaraw_combine(exp_tag, bstrap_idx)

RESULT_PATH = strcat('./debug_data/', exp_tag, '_bstrap', num2str(bstrap_idx), '.mat');

home_directory = readParam('home_directory', 1)

vec = zeros(1,3043);
vec([2,3]) = 1;


Dataset_path = strcat('TrafficAnalysis/Dataset/DataMatrix/');
monitor_dataset = strcat(Dataset_path, exp_tag, '/');
argMap = containers.Map();
argMap('monitor_dataset') = monitor_dataset;
argMap('prior_filename') = strcat(exp_tag, '_prior.mat');

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
