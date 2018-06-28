% for multiple case
% Let's assume: for each dimension, the number of evaluated points is equal
% the only difference is the step


% Bootstrap: single feature
clear;
%Bootstrap Number
BooNum = 2;

[TrainMatrix,Label1] = TrainMatrixRead(0,99);


% suppose we do 1st feature for 1st website

findex = [1 2 3 4 5 6];

webindex = 1;
spots = 10;
step = [200;5;100;4;100;5];
base = [100;60;100;0;100;10];

dim = length(findex);

err = [];

sample = TrainMatrix(Label1==webindex,findex);
sample = sample';       % consistent with kde interface

[fea_num, sam_num] = size(sample);

% model 
p = kde(sample, 'ROT');

[err_ground,test] = Error_Dimen(p,dim,spots,step,base);


for i = 1:BooNum
    rnumber = randi(sam_num,1,sam_num);
    NewSample = sample(:,rnumber);
    pdf = kde(NewSample, 'ROT');

    temp = abs(Error_Dimen(pdf,dim,spots,step,base)-err_ground);
    err = [err,temp];
end

% ave_err
ave_err = mean(err,2);



