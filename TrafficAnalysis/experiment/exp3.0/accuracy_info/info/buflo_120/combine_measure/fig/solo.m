addpath('../../../../../post-process/');
addpath('../../../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../../../attack/MIanalysis/');





prior_ent = GetPriorEnt();

JobRecordFusion('../../individual_measure/jobrecord/JobRecord_buflo_120_fidx41_iter1.mat', prior_ent)
