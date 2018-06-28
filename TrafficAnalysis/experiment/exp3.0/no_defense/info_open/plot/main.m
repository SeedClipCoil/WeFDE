% main

addpath('../../..//post-process/');
addpath('../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../attack/MIanalysis/');


plotArg_500 = containers.Map();
plotArg_500('marker') = 's';
plotArg_500('color') = 'r';

plotArg_1000 = containers.Map();
plotArg_1000('marker') = 'o';
plotArg_1000('color') = 'g';

plotArg_2000 = containers.Map();
plotArg_2000('marker') = '^';
plotArg_2000('color') = 'k';

tag = {'Total', 'Pkt. Count', 'Time', 'Ngram', 'Transposition', 'Interval-I', 'Interval-II', 'Interval-III', 'Pkt. Distribution', 'Burst', 'First20', 'First30 Pkt. Count','Last30 Pkt. Count', 'Pkt. per Second', 'CUMUL'};
for i = 1:15
%figure;
subplot(3,5,i);
res1 = drawCategory('openw_top500',i, plotArg_500);
hold on;
res2 = drawCategory('openw_top1000',i, plotArg_1000);
res3 = drawCategory('openw_top2000', i, plotArg_2000);
hold off;
title(tag{i}, 'FontSize', 14)

if i == 1
    % add legend
    lg = legend([res1, res2, res3], 'top500', 'top1000', 'top2000', 'Location', 'southeast');
    set(lg, 'FontSize', 10);
end
if i == 6
    ylabel('Information Leakage (Bit)', 'FontSize', 14);
end
if i == 13
    xlabel('Number of Most Informative Features', 'FontSize', 14);
end

end

%saveas(gcf, strcat('openw_', num2str(0), '.pdf'));


% subplot(4,4,1);
% drawCategory(1);
% title('total');
% 
% subplot(4,4,2);
% drawCategory(2);
% title('pkt num');
% 
% subplot(4,4,3);
% drawCategory(3);
% title('pkt time');
% 
% subplot(4,4,4);
% drawCategory(4);
% title('ngram');
% 
% subplot(4,4,5);
% drawCategory(5);
% title('trans position');
% 
% subplot(4,4,6);
% drawCategory(6);
% title('knn interval');
% 
% subplot(4,4,7);
% drawCategory(7);
% title('icics interval');
% 
% subplot(4,4,8);
% drawCategory(8);
% title('wpes11 interval');
% 
% subplot(4,4,9);
% drawCategory(9);
% title('pkt distribution');
% 
% subplot(4,4,10);
% drawCategory(10);
% title('burst');
% 
% subplot(4,4,11);
% drawCategory(11);
% title('first20');
% 
% subplot(4,4,12);
% drawCategory(12);
% title('first30 pkt num');
% 
% subplot(4,4,13);
% drawCategory(13);
% title('last30 pkt num');
% 
% subplot(4,4,14);
% drawCategory(14);
% title('pkt per second');
% 
% subplot(4,4,15);
% drawCategory(15);
% title('cumul');