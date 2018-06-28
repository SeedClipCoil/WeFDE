%function results = solo(tag)
%function info = solo_combine(exp_tag, category_idx, topn, bstrap_idx)

addpath('../../../parallel_measure')
addpath('../../../ToolBox/util/')
addpath('../../../ToolBox/')
addpath('../../../../MIanalysis/');


exp_tag = 'openw_top2000';
category_idx = 1;
topn = 100;
bstrap_idx = 0;

RESULT_PATH = strcat('./debug_data/', exp_tag, '_category', num2str(category_idx), '_topn', num2str(topn), '_bstrap', num2str(bstrap_idx), '.mat');

home_directory = readParam('home_directory', 1)
MIanalysis_path = strcat(home_directory, 'experiment/exp3.0/no_defense/info/top100/combine_measure/MIanalysis/MIanalysis_cat', num2str(category_idx), '_topn', num2str(topn), '.mat');

m = importdata(MIanalysis_path);
vec =m.vec;


Dataset_path = strcat('TrafficAnalysis/Dataset/DataMatrix/');

% set monitor dataset path
monitor_dataset = strcat(Dataset_path, 'monitor', '/');
argMap = containers.Map();
argMap('monitor_dataset') = monitor_dataset;

% set non-monitor dataset path
non_monitor_dataset = strcat(Dataset_path, exp_tag, '/');
argMap('non_monitor_dataset') = non_monitor_dataset;

argMap('prior_filename') = strcat(exp_tag, '_prior.mat');

% build the model
if bstrap_idx == 0
    % no bootstrap
    info = model_init(vec, 0, 1, argMap);
else
    info = model_init(vec, 1, 1, argMap);
end



webNum = length(info.WebsiteList);


c = gcp('nocreate');
if isempty(c)
  parallel_handler(32);
end





reader_monitor = TrainMatrixReader(monitor_dataset, 10000000000);

reader_non_monitor = TrainMatrixReader(non_monitor_dataset, 100000000);
rank = [reader_monitor.Rank; reader_non_monitor.Rank];
% let's calculate KL first



% generate samples
info.GenerateSamples(20000);

[top500_prior, idx500] = topnPrior(rank, info.MonitorFlag, 500);
top1000_prior = topnPrior(rank, info.MonitorFlag, 1000);
top2000_prior = topnPrior(rank, info.MonitorFlag, 2000);





% evaluate samples

batch_idx = 1;
for i = 1:webNum
  sample_num = size(info.SampleList{i}, 1);
  for j = 1:sample_num
    batchList{batch_idx} = [i,j];
    batch_idx = batch_idx + 1;
  end
end


parfor i = 1:length(batchList)
%  disp(['category',num2str(category_idx), ':webNum:', num2str(i)]); 
  web_idx = batchList{i}(1);
  ist_idx = batchList{i}(2);
  temp = info.evaluateKernel(web_idx, [ist_idx]);
  batch_results{i} = temp{web_idx}{ist_idx};
end

for i = 1:length(batchList)
  web_idx = batchList{i}(1);
  ist_idx = batchList{i}(2);
  JobResults{web_idx}{ist_idx} = batch_results{i};
end



results.JobResults = JobResults;
Mflag = info.MonitorFlag;
save(RESULT_PATH, 'results', 'Mflag', 'rank');












%KL_500_1000 = 0;
%KL_500_2000 = 0;
%counter = 0;
%
%for wi = idx500 
%  web_collect = whole_collect{wi};
%  for si = 1:length(web_collect)
%    log_prob = web_collect{si};
%    
%    % in case top500
%    wi
%    divert = KL_Divergence(log_prob, top500_prior, top1000_prior, info.MonitorFlag)
%
%    KL_500_1000 = KL_500_1000 + divert;
%    divert = KL_Divergence(log_prob, top500_prior, top2000_prior, info.MonitorFlag);
%    KL_500_2000 = KL_500_2000 + divert;
%    counter = counter + 1;
%  end
%end
%
%

















