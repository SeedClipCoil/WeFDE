function res = drawCategory(exp_tag, cat_num, arg)


selector = GetSelector();

category = cat_num;

bstrap = 0;

fnumber = selector{category}{2};


prior_path = strcat('../', exp_tag, '/combine_measure/jobrecord/', exp_tag, '_prior.mat');

prior_ent = GetPriorEnt(prior_path, 1)

%%%%%%%%%%%% direct measure %%%%%%%%%%
ent_direct = [];

for i = fnumber
    path = strcat('../',exp_tag, '/combine_measure/jobrecord/JobRecord_', exp_tag, '_category', int2str(category), '_topn', int2str(i), '_bstrap0', '.mat');
    ms = JobRecordFusion(path, prior_ent);
    ent_direct = [ent_direct, ms];
end



%%%%%%%%%%%  bootstrap %%%%%%%%
for i = fnumber
    for j = 1:bstrap
        path = strcat('../', exp_tag, '/combine_measure/jobrecord/JobRecord_', exp_tag, '_category', int2str(category), '_topn', int2str(i), '_bstrap', int2str(j), '.mat');
        ent_bstrap{fnumber==i}(j) = JobRecordFusion(path, prior_ent);
    end
end




%%%%%% compute true feature numbers instead of fnumber
true_num = [];
for i =fnumber
    path = strcat('../', exp_tag, '/combine_measure/MIanalysis/MIanalysis_cat', num2str(category), '_topn', num2str(i), '.mat');
    m = importdata(path);
    num = length(m.topnFeatureList);
    true_num = [true_num, num];
end




if bstrap ~= 0
    PlotCI(true_num, ent_direct, ent_bstrap);
else
    pro = strcat('-', arg('color'), arg('marker'));
    res = plot(true_num, ent_direct, pro, 'MarkerFaceColor', arg('color'), 'MarkerEdgeColor', 'w', 'MarkerSize', 6, 'LineWidth', 0.5);
end

xmax = max(true_num) + 1;

axis([0 xmax 0 2]);

hold on;
pro = strcat(':', arg('color'));
plot(0:100, zeros(1,101) + prior_ent, pro, 'LineWidth', 1);







end


