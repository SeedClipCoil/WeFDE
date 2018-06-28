function [ci,prior] = Dmeasure(si, ei)
RESULTPATH = 'category/';

ci = [];

for i = si:ei
    pathname = strcat(RESULTPATH, 'ent_summary_', int2str(i), '.mat');
    x = importdata(pathname);
    
    ci = [ci, GetPriorEnt - OneMean(x{1})];
    
end

prior = GetPriorEnt();

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
ent = log2(100);
end






