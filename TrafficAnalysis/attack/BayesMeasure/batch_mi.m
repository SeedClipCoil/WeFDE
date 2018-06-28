% MI batch

addpath('ToolBox');

clear;

% no_defense

reader = TrainMatrixReader('dataset/no_defense/', 0, 99);
vec = zeros(1,43);
info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
mi_matrix = info.MI(1);

save('experiment/no_defense/mi/mi.mat', 'mi_matrix');
     
clear;


% tamaraw
reader = TrainMatrixReader('dataset/Tamaraw/', 0, 99);
vec = zeros(1,43);
info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
mi_matrix = info.MI(1);

save('experiment/tamaraw/mi/mi.mat', 'mi_matrix');

clear;

% tamaraw_no_obfuscate
reader = TrainMatrixReader('dataset/Tamaraw_no_obfuscate/', 0, 99);
vec = zeros(1,43);
info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
mi_matrix = info.MI(1);

save('experiment/tamaraw_no_obfuscate/mi/mi.mat', 'mi_matrix');
     
clear;

% BuFLO
reader = TrainMatrixReader('dataset/BuFLO/', 0, 99);
vec = zeros(1,43);
info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
mi_matrix = info.MI(1);

save('experiment/BuFLO/mi/mi.mat', 'mi_matrix');

clear;

% BuFLO_50
reader = TrainMatrixReader('dataset/BuFLO_50/', 0, 99);
vec = zeros(1,43);
info = EvaluatorMachine(reader.TrainMatrix, reader.Label, vec);
mi_matrix = info.MI(1);

save('experiment/BuFLO_50/mi/mi.mat', 'mi_matrix');
     
 