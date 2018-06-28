% information measure
clear;




% grouping by dependence
%vec = [[2 24 0 17 0 2 2 1 0 12],[0 10 0 2 0 0 0 0 11 11],[4 4 4 11 25 19 15 7 26 3],[20 18 22 9 21 23 5 14 27 13],[6 16 8]];

addpath('ToolBox');

reader = TrainMatrixReader('data/', 0, 99);

%info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
%mi = info.MI(100);
%info.GenerateSamples(1);
%ent = info.Evaluate();
%[prob_summary,right,wrong] = info.ClassifySimulator();



% entropy for each bit
% ent_summary: row->one experiment with a bit; column->different samples (websites)


% parameters
bstrap_num = 50;
mcarlo_num = 50;


% variables for collecting values
ent_summary = cell(43,1);
info_list = cell(43,1);

parfor i = 1:43
     i
     vec = zeros(1,43);
     vec(i) = 1;
     
     info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
     info_list{i} = info;
     
     ent_bs = [];
     
     for j = 1:bstrap_num
         info.reModel();
         info.GenerateSamples(mcarlo_num);
         ent = info.Evaluate();
         ent_bs = [ent_bs; ent];
     end
     
     ent_summary{i} = ent_bs;
     
     % debug: backup ent
     pathname = strcat('debug/ent_bs_', int2str(i), '.mat');
     parsave(pathname, ent_bs);    
    
    
end