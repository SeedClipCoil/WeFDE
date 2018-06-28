%%%% plot 
clear;


addpath('../../post-process/');
addpath('../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../attack/MIanalysis/');



buflo_plot = containers.Map();
buflo_plot('color') = 'r';

no_plot = containers.Map();
no_plot('color') = 'g';

wtf_plot = containers.Map();
wtf_plot('color') = 'k';

super_plot = containers.Map();
super_plot('color') = 'b';


[info_no, acc_no, prior_ent_no] = tamaraw_no();

% [info_with, acc_with] = tamaraw_with();

[info_buflo, acc_buflo, prior_ent_buflo] = buflo();

[info_wtf, acc_wtf, prior_ent_wtf] = wtf();

[info_super3, acc_super3, prior_ent_super3] = supersequence_3();
[info_super4, acc_super4, prior_ent_super4] = supersequence_4();

[info_cs_buflo, acc_cs_buflo, prior_ent_cs_buflo] = cs_buflo();

% ax = plot(acc_no, info_no, 'ro');
% set(gca,'fontsize',12, 'XScale', 'log');
% hold on;
% % plot(acc_with, info_with, 'b*');
% 
% plot(acc_buflo, info_buflo, 'g+');
% 
% plot(acc_wtf, info_wtf, 'kx')
% 
% 


% axes('Position',[0.1,0.1,0.7,0.7]);


%%% draw rectangle

% plot buflo
for i = 1:length(info_buflo)
    [info_low, info_up] = ConfidenceInterval(info_buflo{i}(2:end), 1);
    [acc_low, acc_up] = AccInterval(acc_buflo(i));
    rectangle('Position', [acc_low,info_low,(acc_up-acc_low),(info_up-info_low)], 'FaceColor', 'r', 'LineStyle', 'none');
    hold on;
end



% plot tamaraw
for i = 1:length(info_no)
    [info_low, info_up] = ConfidenceInterval(info_no{i}(2:end), 1);
    [acc_low, acc_up] = AccInterval(acc_no(i));
    rectangle('Position', [acc_low,info_low,(acc_up-acc_low),(info_up-info_low)], 'FaceColor', 'b', 'LineStyle', 'none');
    hold on;
end

% plot wtf
for i = 1:length(info_wtf)
    [info_low, info_up] = ConfidenceInterval(info_wtf{i}(2:end), 1);
    [acc_low, acc_up] = AccInterval(acc_wtf(i));
    if abs(info_low - info_up) < 0.02
        info_up = info_low + 0.02;
    end
    rectangle('Position', [acc_low,info_low,(acc_up-acc_low),(info_up-info_low)], 'FaceColor', 'm', 'LineStyle', 'none');
    hold on;
end


% plot supersequence 3
for i = 1:length(info_super3)
    [info_low, info_up] = ConfidenceInterval(info_super3{i}(2:end), 1);
    [acc_low, acc_up] = AccInterval(acc_super3(i));
    rectangle('Position', [acc_low,info_low,(acc_up-acc_low),(info_up-info_low)], 'FaceColor', 'k', 'LineStyle', 'none');
    hold on;
end

% plot supersequence 4
for i = 1:length(info_super4)
    [info_low, info_up] = ConfidenceInterval(info_super4{i}(2:end), 1);
    [acc_low, acc_up] = AccInterval(acc_super4(i));
    if info_low == info_up
        % equal
        info_up = info_up + 0.02;
    end
    rectangle('Position', [acc_low,info_low,(acc_up-acc_low),(info_up-info_low)], 'FaceColor', 'g', 'LineStyle', 'none');
    hold on;
end




% plot cs_buflo
[info_low, info_up] = ConfidenceInterval(info_cs_buflo{1}(2:end), 1);
[acc_low, acc_up] = AccInterval(acc_cs_buflo(1));

if info_low == info_up
    % equal
    info_up = info_up + 0.02;
end
rectangle('Position', [acc_low,info_low,(acc_up-acc_low),(info_up-info_low)], 'FaceColor', 'y', 'LineStyle', 'none');
hold on;

% PlotCI(acc_buflo, info_buflo, buflo_plot);
% hold on;
% PlotCI(acc_no, info_no, no_plot);
% 
% % axes('Position',[0.5,0.1,0.3,0.3]);
% PlotCI(acc_wtf, info_wtf, wtf_plot);
% PlotCI(acc_super, info_super, super_plot);

%line([0,1], [prior_ent_buflo, prior_ent_buflo]);

xlabel('Accuracy', 'FontSize', 14);
ylabel('Information Leakage', 'FontSize', 14);
legend('BuFLO', 'Tamaraw (without obfuscation)', 'WTF-PAD', 'Location', 'southeast');









