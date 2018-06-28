% only test for highMIpruner
% test program
clear;

dataset_path = '../InfoMeasure/DataMatrix/closed/';

% readParam function
addpath('../InfoMeasure/ToolBox/util/');
addpath('../InfoMeasure/ToolBox/');


experiment_path = 'TrafficAnalysis/experiment/exp2.0/closed_nodefense/equal_prior/';


addpath('../InfoMeasure/ToolBox/');
dataset_path = '../InfoMeasure/DataMatrix/closed/';
ent_path = strcat(experiment_path, 'individual_measure/results/ave_entropy.mat');
fidx = importdata('fidx.mat');


MIgene = MIgenerator(dataset_path);

MIprun = highMIpruner(MIgene);


MIprun.run(fidx, 10);
