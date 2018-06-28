addpath('../../../parallel_measure')
addpath('../../../ToolBox/util/')
addpath('../../../ToolBox/')
addpath('../../../../MIanalysis/');


parallel_handler(8);

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

%exp_tag = {'top100'};



% cs_buflo
%exp_tag = {'cs_buflo'};

% closed world
exp_tag = {'top100'};

bstrap_num = 51;

for e = 1:length(exp_tag)
  for k = 51:bstrap_num
    solo_combine(exp_tag{e}, 1, 100, k);
	end
end
