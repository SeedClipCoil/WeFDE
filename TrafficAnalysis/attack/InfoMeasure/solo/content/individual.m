addpath('../../parallel_measure')
addpath('../../ToolBox/util/')
addpath('../../ToolBox/')


parallel_handler(8);







%exp_tag = {'ImageNumDataMatrix'};
exp_tag = {'JavascriptNumDataMatrix'};




for i = 1:length(exp_tag)
  % each experiment
  tag = exp_tag{i}
  parfor idx = 1:3043 
%  for idx = 1:1 
    solo_individual(tag, idx, 0);
  end
end


%% supersequence
%exp_tag = {};
%count = 1;
%
%for cluster = [2:2:10, 20, 35, 50]
%  exp_tag{count} = strcat('supersequence_method4supercluster2_clusternum', num2str(cluster), '_stoppoints4');
%  count = count + 1;
%end
%
%for supercluster = [2,5,10]
%  for stop = [4,8,12]
%    exp_tag{count} = strcat('supersequence_method3supercluster', num2str(supercluster), '_clusternum20_stoppoints', num2str(stop));
%    count = count + 1;
%  end	
%end
%
%bootstrap_num = 50;
%
%
%for i = 1:length(exp_tag)
%  % each experiment
%  tag = exp_tag{i}
%  idx = [2,3];
%  parfor bstrap = 0:bootstrap_num 
%    solo_individual(tag, idx, bstrap);
%  end
%end
