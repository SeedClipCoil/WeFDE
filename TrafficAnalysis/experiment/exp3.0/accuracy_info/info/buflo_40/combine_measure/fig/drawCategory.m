function res = drawCategory(cat_num)
addpath('../../../../../post-process/');
addpath('../../../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../../../attack/MIanalysis/');



selector = GetSelector();


category = cat_num;

bstrap = 0;

fnumber = selector{category}{2};

prior_ent = GetPriorEnt();

%%%%%%%%%%%% direct measure %%%%%%%%%%
ent_direct = [];

for i = fnumber
    path = strcat('../jobrecord/JobRecord_buflo_40_category', int2str(category), '_topn', int2str(i), '_bstrap0', '.mat');
    ms = JobRecordFusion(path, prior_ent);
    ent_direct = [ent_direct, ms];
end



%%%%%%%%%%%  bootstrap %%%%%%%%
for i = fnumber
    for j = 1:bstrap
        path = strcat('../jobrecord/JobRecord_buflo_40_category', int2str(category), '_topn', int2str(i), '_bstrap', int2str(j), '.mat');
        ent_bstrap{fnumber==i}(j) = JobRecordFusion(path, prior_ent);
    end
end




%%%%%% compute true feature numbers instead of fnumber
true_num = [];
for i =fnumber
    path = strcat('../MIanalysis/MIanalysis_cat', num2str(category), '_topn', num2str(i), '.mat');
    m = importdata(path);
    num = length(m.topnFeatureList);
    true_num = [true_num, num];
end




if bstrap ~= 0
    PlotCI(true_num, ent_direct, ent_bstrap);
else
    plot(true_num, ent_direct, 'r');
end


axis([0 160 0 7]);
%xlabel('Number of Most Informative Features', 'FontSize', 14);
%ylabel('Information Leakage (Bit)', 'FontSize', 14);

hold on;
plot(true_num, zeros(1,length(true_num)) + prior_ent, '-.k');
res = ent_direct;

end


