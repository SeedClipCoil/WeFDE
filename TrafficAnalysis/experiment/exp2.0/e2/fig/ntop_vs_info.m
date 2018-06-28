% number of top features    vs.     leaked info
addpath('../../post-process/');
addpath('../../../../attack/InfoMeasure/parallel_measure/');
ntop = [1:9,10,25, 50,75,100,125,150];
RESULT_PATH = '../results/';

prior_ent = GetPriorEnt();

Y = [];

for i = ntop
    % each sample
    path = strcat(RESULT_PATH, 'entropy_top', num2str(i), '.mat');
    res = importdata(path)
    Y = [Y,res];
end


plot(ntop, Y, '-or', 'LineWidth', 2);
hold on;
plot(ntop, zeros(1,length(ntop)) + prior_ent, '--k');


% set x/y label
ylabel('Leaked Information (Bit)', 'FontSize', 14);
xlabel('Number of Top Informative Features', 'FontSize', 14);
axis([0 130 0 7]);
grid;