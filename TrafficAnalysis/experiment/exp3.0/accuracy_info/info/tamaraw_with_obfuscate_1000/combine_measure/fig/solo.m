addpath('../../../../../post-process/');
addpath('../../../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../../../attack/MIanalysis/');

prior_ent = GetPriorEnt();

JobRecordFusion('../jobrecord/JobRecord.mat', prior_ent)