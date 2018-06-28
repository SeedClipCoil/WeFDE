function [ci, ent]= ConInterval(si, ei)
%RESULTPATH = 'individual_subsampling/';
RESULTPATH = 'category/';

ci = [];

for i = si:ei
    temp_ci = zeros(1,3);
    pathname = strcat(RESULTPATH, 'ent_summary_', int2str(i), '.mat');
    x = importdata(pathname);
    
    ent_mean = GetMean(x);
    
    temp_ci(1) = GetPriorEnt - ent_mean(1);
    
    
    ent_mean_sort = sort( ent_mean(2:51) );
    temp_ci(3) = GetPriorEnt - ent_mean_sort(3);
    temp_ci(2) = GetPriorEnt - ent_mean_sort(48);

    ci = [ci;temp_ci];
    ent = GetPriorEnt;
end



end

% get a list of mean for all experiment
function res = GetMean(summary)
num_exp = length(summary);
res = zeros(num_exp, 1);
for i = 1:num_exp
    res(i) = OneMean(summary{i});
end

end


% return ent mean for a single experiment
function res = OneMean(data)
web_num = length(data);
counter = 0;
ent = 0;
for i = 1:web_num
    for j = 1:length(data{i})
        ent = ent + data{i}(j);
        counter = counter + 1;
    end
end


res = ent/counter;
end



function ent = GetPriorEnt()
prior = importdata('../prior.mat');
num = length(prior);
ent = 0;

for i = 1:num
    if prior(i) ~= 0
        ent = ent - prior(i) * log2(prior(i));
    end
end
end







