% main
clear;
addpath('../../post-process/');
addpath('../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../attack/MIanalysis/');

[info_leak_tamaraw, max_info_tamaraw] = plot_tamaraw();
[info_leak_buflo, max_info_buflo] = plot_buflo();
[info_leak_wtf, max_info_wtf] = plot_wtf();


world_size = [500, 1000, 2000];


msize = 8;
lsize = 3;

% tamaraw
plot(world_size, info_leak_tamaraw(1:3), ':xr', 'MarkerSize', msize, 'LineWidth', lsize);
hold on;
plot(world_size, info_leak_tamaraw(4:6), ':.r', 'MarkerSize', msize, 'LineWidth', lsize);
plot(world_size, info_leak_tamaraw(7:9), ':^r', 'MarkerSize', msize, 'LineWidth', lsize);



% buflo
plot(world_size, info_leak_buflo(1:3), ':og', 'MarkerSize', msize, 'LineWidth', lsize);
plot(world_size, info_leak_buflo(4:6), ':+g', 'MarkerSize', msize, 'LineWidth', lsize);
plot(world_size, info_leak_buflo(7:9), ':>g', 'MarkerSize', msize, 'LineWidth', lsize);


% WTF
plot(world_size, info_leak_wtf, ':*b', 'MarkerSize', msize, 'LineWidth', lsize);


% maximum, tamaraw equal with buflo
plot(world_size, max_info_buflo(1:3), ':sk', 'MarkerSize', msize, 'LineWidth', lsize);

axis([400 2100 2 12]);


legend('Tamaraw (L=100)', 'Tamaraw (L=500)', 'Tamaraw (L=1000)', 'BuFLO (\tau=20)', 'BuFLO (\tau=60)', 'BuFLO (\tau=120)', 'WTF-PAD (0.9)', 'Upper Bound', 'Location', 'east');

xlabel('the Closed-world Size', 'FontSize', 14);
ylabel('Total Information Leakage (bit)', 'FontSize', 14);











