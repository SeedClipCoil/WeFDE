
MIpath = 'TrafficAnalysis/experiment/exp3.0/no_defense/info/top100/combine_measure/MIanalysis/MIanalysis_cat1_topn100.mat';

datapath = 'TrafficAnalysis/Dataset/DataMatrix/top100/';

tmpath = strcat(datapath, 'TrainMatrix.mat');
rkpath = strcat(datapath, 'Rank.mat');
lpath = strcat(datapath, 'Label.mat');
dvpath = strcat(datapath, 'isDiscVec.mat');

rawdata = load(tmpath);



top100 = load(MIpath);
trainMatrix = rawdata.tempa;


raw = load('TrafficAnalysis/experiment/exp3.0/no_defense/info/top100/individual_measure/results/ave_entropy.mat');

ent = raw.ave;
[val,idx] = sort(ent, 'descend');




% pick out by ent. ranking
select = 3035;
reduceMatrix = trainMatrix(:,idx(1:select));


% pick out top100 by MI results
%reduceMatrix = trainMatrix(:, top100.topnFeatureList);





% delete columns with zero variance
%colnum = size(trainMatrix, 2);
%for col = colnum:-1:1
%  if var(trainMatrix(:,col)) == 0
%    trainMatrix(:,col) = [];
%  end
%end

[coeff,score,latent,tsquared,explained,mu] = pca(reduceMatrix, 'Centered', true, 'VariableWeights', 'variance');

compNum = 50;

tempa = reduceMatrix * coeff(:,1:compNum);
tempb = importdata(lpath);
tempc = importdata(rkpath);
tempd = importdata(dvpath);


save('TrainMatrix.mat', 'tempa', '-v7.3');
save('Label.mat', 'tempb', '-v7.3');
save('Rank.mat', 'tempc', '-v7.3');
save('isDiscVec.mat', 'tempd', '-v7.3');
