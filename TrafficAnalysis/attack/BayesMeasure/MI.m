% measuring infomation of the individual bit
clear;
addpath('ToolBox');





reader = TrainMatrixReader('data/', 0, 99);
vec = zeros(1,43);

info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
mi_matrix = info.MI(1);

save('debug/mi.mat', 'mi_matrix');
     
     
     
 