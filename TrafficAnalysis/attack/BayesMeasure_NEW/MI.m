% measuring infomation of the individual bit
clear;
addpath('ToolBox');


reader_closed = TrainMatrixReader('dataset_open_world/monitored/no_defense/');
reader_open = TrainMatrixReader('dataset_open_world/non_monitored/no_defense/');


Tmatrix{1} = reader_closed.TrainMatrix;
label{1} = reader_closed.Label;
Tmatrix{2} = reader_open.TrainMatrix;
label{2} = reader_open.Label;

prior = PriorWebsites('Open_World_Zipf', reader_closed.Rank, reader_open.  Rank);

vec = zeros(1,43);

info = EvaluatorMachine(Tmatrix, label, vec, prior);




mi_matrix = info.MI(1);

save('debug/mi.mat', 'mi_matrix');
     
     
     
 
