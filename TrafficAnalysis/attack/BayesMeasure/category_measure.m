function category_measure(vec, findex)

addpath('ToolBox');


% parameters
bstrap_num = 0;
mcarlo_num = 50;
reModel_krate = 0.5;

% selector:     bootstrap 1; subsampling 2
selector = 1;

reader = TrainMatrixReader('dataset/no_defense/', 0, 99);



info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);

ent_summary = cell(bstrap_num,1);


% direct measure
info.GenerateSamples(mcarlo_num);
ent_summary{1} = info.Evaluate();

% for parallel 

% for i = 1:bstrap_num
%     info_list{i} = info;
% end
% 
% parfor j = 1:bstrap_num
%     j
%     info_list{j}.reModel(reModel_krate, selector);
%     info_list{j}.GenerateSamples(mcarlo_num);
%     ent = info_list{j}.Evaluate();
%     ent_summary{j+1} = ent;
% end

% save ent_summary
pathname = strcat('debug/ent_summary_', int2str(findex), '.mat');
save(pathname, 'ent_summary');



end

