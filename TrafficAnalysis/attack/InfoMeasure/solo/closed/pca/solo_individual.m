function info = solo_individual(tag, idx, bootstrap)


%RESULT_PATH = strcat('./debug_data/JobRecord_', tag, '_category1_top100_bstrap', num2str(bootstrap), '.mat');

RESULT_PATH = strcat('./debug_data/', 'JobRecord_', tag, '_fidx', num2str(idx), '_iter1.mat');


argMap = containers.Map();
%argMap('prior_filename') = strcat(tag, '_prior.mat');
argMap('monitor_dataset') = strcat('TrafficAnalysis/attack/KNN/Dataset/DataMatrix/', tag, '/');

vec = zeros(1,3043);

vec(idx) = 1;
if bootstrap == 0
  info = model_init(vec, 0, 0, argMap);
else
  info = model_init(vec, 1, 0, argMap);
end



webNum = length(info.WebsiteList);


for i = 1:webNum
  temp = info.Evaluate(i, []);
  res{i} = temp{i};
end


results.JobResults = res;

save(RESULT_PATH, 'results');


end
