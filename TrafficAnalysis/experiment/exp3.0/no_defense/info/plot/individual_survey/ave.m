top100 = importdata('../../top100/individual_measure/results/ave_entropy.mat');
top500 = importdata('../../top500/individual_measure/results/ave_entropy.mat');
top1000 = importdata('../../top1000/individual_measure/results/ave_entropy.mat');


[top100_max, top100_max_idx] = max(top100);
[top500_max, top500_max_idx] = max(top500);
[top1000_max, top1000_max_idx] = max(top1000);



% give a pie plot

b3 = sum(top100<3)/3043;
b2 = sum(top100<2)/3043;
b1 = sum(top100<1)/3043;


% pie plot
%piex = [b3, b2-b3, b1-b2, 3043-b1];
%labels = {'more than 3 bits', '2 bits ~ 3 bits', '1 bit ~ 2 bits', 'smaller than 1 bit'};
%pie(piex, labels);



% ecdf plot
[f,x] = ecdf(top100);
figure;
set(gca,'fontsize',14)
plot(x,f, 'r', 'LineWidth', 4);




xlabel('Information Leakage');
ylabel('Empirical Cumulative Distribution Function');
axis([0 3.46 0 1]);
hold on;
line([3 3], [0 b3], 'Color', 'black', 'LineStyle', ':', 'LineWidth', 2);
line([2 2], [0 b2], 'Color', 'black', 'LineStyle', ':', 'LineWidth', 2);
line([1 1], [0 b1], 'Color', 'black', 'LineStyle', ':', 'LineWidth', 2);






