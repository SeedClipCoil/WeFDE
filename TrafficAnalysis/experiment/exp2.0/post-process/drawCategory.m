function res = drawCategory(cat_num)
addpath('../../../../post-process/');
addpath('../../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../../attack/MIanalysis/');



selector = GetSelector();


category = cat_num;

bstrap = 0;

fnumber = selector{category}{3};

prior_ent = GetPriorEnt();

%%%%%%%%%%%% direct measure %%%%%%%%%%
ent_direct = [];

for i = fnumber
    path = strcat('../jobrecord/JobRecord_category', int2str(category), '_topm', int2str(i), '_bstrap0', '.mat');
    ms = JobRecordFusion(path, prior_ent);
    ent_direct = [ent_direct, ms];
end



%%%%%%%%%%%  bootstrap %%%%%%%%
for i = fnumber
    for j = 1:bstrap
        path = strcat('../jobrecord/JobRecord_category', int2str(category), '_topm', int2str(i), '_bstrap', int2str(j), '.mat');
        ent_bstrap{fnumber==i}(j) = JobRecordFusion(path, prior_ent);
    end
end



%%%%%%%%%%%% get actual number of features without highly MI %%%%%%%%%%%%
actual_fnumber = [];

for i = fnumber
    path_MI = strcat('../MIanalysis/MIanalysis_', num2str(category), '.mat');
    m = importdata(path_MI);
    m.MItopm(i);
    m.EliminateHighMI(0.9);
    vec = m.GroupByMI(0.4);
    actual_fnumber = [actual_fnumber, sum(vec > 0)];
end




actual_fnumber

fnumber




if bstrap ~= 0
    PlotCI(actual_fnumber, ent_direct, ent_bstrap);
else
    plot(actual_fnumber, ent_direct, 'b');
    hold on;
    plot(fnumber, ent_direct, 'r');
end

axis([0 160 0 7]);
%xlabel('Number of Most Informative Features', 'FontSize', 14);
%ylabel('Information Leakage (Bit)', 'FontSize', 14);

hold on;
plot(fnumber, zeros(1,length(fnumber)) + prior_ent, ':b');
res = ent_direct;

end


