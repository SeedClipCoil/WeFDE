% test program
clear;
% readParam function
addpath('../InfoMeasure/ToolBox/util/');
addpath('../InfoMeasure/ToolBox/');


experiment_path = 'TrafficAnalysis/experiment/exp2.0/closed_nodefense/equal_prior/';


addpath('../InfoMeasure/ToolBox/');
dataset_path = '../InfoMeasure/DataMatrix/closed/';
ent_path = strcat(experiment_path, 'individual_measure/results/ave_entropy.mat');

ent = importdata(ent_path);



m = MIanalysis(dataset_path, ent);



m.setup(1:3043, 100);


vec = m.groupByMI();

