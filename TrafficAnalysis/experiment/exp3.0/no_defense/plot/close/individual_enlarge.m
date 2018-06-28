clear;

addpath('../../../post-process/')
addpath('../../../../../attack/MIanalysis/');

top1000 = importdata('../../info/top1000/individual_measure/results/ave_entropy.mat');
top500 = importdata('../../info/top500/individual_measure/results/ave_entropy.mat');
top100 = importdata('../../info/top100/individual_measure/results/ave_entropy.mat');



for i = 1:3043
    ave(i) = mean([top1000(i), top100(i), top500(i)]);
    upper(i) = max([top1000(i), top100(i), top500(i)]);
    lower(i) = min([top1000(i), top100(i), top500(i)]);

end





% get selector

selector = GetSelector();



tag = {'Pkt. Count', 'Time', 'Ngram', 'Transposition', 'Interval-I', 'Interval-II', 'Interval-III', 'Pkt. Distribution', 'Burst', 'First20', 'First30 Pkt. Count','Last30 Pkt. Count', 'Pkt. per Second', 'CUMUL'};



for i = 2:15
    

idx_set = selector{i}{1};

xmax = max(idx_set);
xmin = min(idx_set);


subplot(3,5,i-1);

set(gca,'fontsize',14);

plot(idx_set, top100(idx_set), 'r', 'LineWidth', 1);
hold on;
plot(idx_set, top500(idx_set), 'g', 'LineWidth', 1);
plot(idx_set, top1000(idx_set), 'k', 'LineWidth', 1);

set(gca, 'XTick', [xmin xmax]);

axis([xmin xmax 0 4]);

grid on;
title(tag{i-1}, 'FontSize', 14);




if i == 2 
%    ylabel('Information Leakage', 'position', [ -2 -1 0], 'FontSize', 14);
    lh = legend('top100', 'top500', 'top1000');
    set(lh, 'Location', 'south');
end
if i == 7
%    ylabel('Information Leakage', 'position', [ -2 -1 0], 'FontSize', 14);
   ylabel('Information Leakage (bit)', 'FontSize', 14);

end
if i == 14
%    xlabel('Feature Index', 'position', [3600, -0.5, 0], 'FontSize', 14);
    xlabel('Feature Index', 'FontSize', 14);

end


end







