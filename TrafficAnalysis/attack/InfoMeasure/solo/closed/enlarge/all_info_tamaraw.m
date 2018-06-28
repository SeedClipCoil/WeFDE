addpath('../../../parallel_measure')
addpath('../../../ToolBox/util/')
addpath('../../../ToolBox/')
addpath('../../../../MIanalysis/');


parallel_handler(32);

% buflo
% exp_tag = {'buflo_5', 'buflo_10', 'buflo_20', 'buflo_30', 'buflo_40', 'buflo_50', 'buflo_60',  'buflo_80', 'buflo_100', 'buflo_120'};



% tamaraw
%exp_tag = {};
%count = 1;
%for i = 10:10:90
%  tag_no = strcat('tamaraw_no_obfuscate_', num2str(i));
%  tag_with = strcat('tamaraw_with_obfuscate_', num2str(i));
%  exp_tag{count} = tag_no;
%  exp_tag{count+1} = tag_with;
%  count = count + 2;
%end


% WTF
%count = 1;
%for i = 6:9
%  wtf = strcat('WTF_0.', num2str(i));
%  exp_tag{count} = wtf;
%  count = count + 1;
%end

exp_tag = {'top1000-tamaraw_no_obfuscate_1000', 'top2000-tamaraw_no_obfuscate_1000', 'top500-tamaraw_no_obfuscate_1000'};

bstrap_num = 0;

for e = 1:length(exp_tag)
	tamaraw_combine(exp_tag{e}, bstrap_num);
end
