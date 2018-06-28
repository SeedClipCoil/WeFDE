% Bootstrap: single feature
clear;
%Bootstrap Number
BooNum = 20;

if exist('../data/TrainMatrix.mat') == 2
    load('../data/TrainMatrix.mat');
else
    [TrainMatrix,Label1] = TrainMatrixRead(0,99);
end


% suppose we do 1st feature for 1st website

findex = 1;
webindex = 1;

range = 1500;
step = 1;

sample = TrainMatrix(Label1==webindex,findex);
%sample = sample(1:);
sam_num = length(sample);

% draw original pdf
pdf = KernelEstimate(sample);
drawdis(pdf,0,range,'r*');
err_ground = Error(pdf,0,range,step);
hold on;

% error
err= [];

for i = 1:BooNum
    rnumber = randi(sam_num,sam_num,1);
    NewSample = sample(rnumber);
    pdf = KernelEstimate(NewSample);
%    drawdis(pdf,10,1500,'-');
    temp = abs(Error(pdf,0,range,step)-err_ground);
    err = [err;temp];
end


% plot err
ave_err = mean(err);
dd = 0:step:range;
plot(dd,ave_err);
err_sum = sum(ave_err);


% percent
% delete very small ave_err for display
ma = max(err_ground);
logic = err_ground<ma*0.05;
ave_err(logic) = 0;

per_err = ave_err./err_ground;

%plot(per_err,'r');
pp = mean(per_err(per_err>0));



