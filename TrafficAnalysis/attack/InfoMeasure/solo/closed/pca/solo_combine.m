%function results = solo(tag)
function info = solo_combine(exp_tag, category_idx, topn, bstrap_idx)

RESULT_PATH = strcat('./debug_data/', exp_tag, '_category', num2str(category_idx), '_topn', num2str(topn), '_bstrap', num2str(bstrap_idx), '.mat');

home_directory = readParam('home_directory', 1)




Dataset_path = strcat('TrafficAnalysis/attack/PCAanalysis/');
monitor_dataset = strcat(Dataset_path, exp_tag, '/');
argMap = containers.Map();
argMap('monitor_dataset') = monitor_dataset;


tm = strsplit(exp_tag, '_');
compNum = str2num(tm{2}); 
vec = zeros(1, compNum) + 1;


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
