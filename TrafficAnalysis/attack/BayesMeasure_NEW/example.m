% example
tic
clear;
addpath('ToolBox');


% parameters
bstrap_num = 0;
mcarlo_num = 2000;
reModel_krate = 0.5;

% selector:     bootstrap 1; subsampling 2
selector = 1;


reader_closed = TrainMatrixReader('dataset/no_defense/', 1, 100);
reader_open = TrainMatrixReader('dataset_open_world/no_defense/', 1, 1500);


Tmatrix{1} = reader_closed.TrainMatrix;
label{1} = reader_closed.Label;
Tmatrix{2} = reader_open.TrainMatrix;
label{2} = reader_open.Label;


prior = PriorWebsites('Open_World_Zipf', reader_closed.Rank, reader_open.Rank);


vec = zeros(43,1);
vec(3) = 1;

info = EvaluatorMachine(Tmatrix, label, vec, prior);


ent_summary = cell(bstrap_num,1);


% direct measure
info.GenerateSamples(mcarlo_num);
ent_summary{1} = info.Evaluate();

%for parallel 
info_list = cell(bstrap_num, 1);
for i = 1:bstrap_num
    info_list{i} = info;
end

parfor j = 1:bstrap_num
    j
    info_list{j}.reModel(reModel_krate, selector);
    info_list{j}.GenerateSamples(mcarlo_num);
    ent = info_list{j}.Evaluate();
    ent_summary{j+1} = ent;
end


% save ent_summary
pathname = strcat('debug/ent_summary_', int2str(findex), '.mat');
save(pathname, 'ent_summary');

toc



