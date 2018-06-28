addpath('../../../../../post-process/');
addpath('../../../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../../../attack/MIanalysis/');





prior_ent = GetPriorEnt();

JobRecordFusion('../jobrecord/JobRecord_buflo_10_fidx114_iter1.mat', prior_ent)
