% measuring infomation of the individual bit
clear;
addpath('ToolBox');


% parameters
bstrap_num = 0;
mcarlo_num = 5;

% subsampling
reModel_krate = 0.5;
% selector:     bootstrap 1; subsampling 2
selector = 2;


%bitset = [3, 4, 5, 6, 8, 12, 13:18, 21:23, 25, 34];
bitset = 1:4;
% variables for collecting values
ent_summary = cell(43,1);
info_list = cell(43,1);



reader = TrainMatrixReader('data/', 0, 99);

parfor i = bitset
     vec = zeros(1,43);
     vec(i) = 1;
     
     info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
     info_list{i} = info;
     
     ent_bs = [];

     % to get the ent
     info.GenerateSamples(mcarlo_num);
     ent = info.Evaluate();
     ent_bs = [ent_bs; ent];
     
     % bootstrap/subsampling
     for j = 1:bstrap_num
         
         if rem(j,5) == 0
             display(i);
             display(j);
         end
         
         info.reModel(reModel_krate, selector);
         info.GenerateSamples(mcarlo_num);
         ent = info.Evaluate();
         ent_bs = [ent_bs; ent];
     end
     
     ent_summary{i} = ent_bs;
     
     % debug: backup ent
     pathname = strcat('debug/ent_', int2str(i), '.mat');
     parsave(pathname, ent_bs);    
    
    
end

save('debug/info_list.mat', 'info_list');

