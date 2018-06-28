% conduct KSG estimator


% import dataset


DATA_PATH = 'TrafficAnalysis/Dataset/DataMatrix/top100/';

lpath = strcat(DATA_PATH, 'Label.mat');
tpath = strcat(DATA_PATH, 'TrainMatrix.mat');


Label = importdata(lpath);
TrainMatrix = importdata(tpath);



newLabel = [];
newTrainMatrix = [];

picknum = 100;


counter = zeros(max(Label),1);

obsnum = length(Label);

for i = 1:obsnum
  lb = Label(i);
  data = TrainMatrix(i,:);
  if counter(lb) < picknum
    % record the label and data
    newLabel = [newLabel; lb];
    newTrainMatrix = [newTrainMatrix; data];

    counter(lb) = counter(lb) + 1;
  end
end


for k = [1,2,5,10]

  [I1, I2] = KraskovMI(newLabel, newTrainMatrix, k)
  sname = strcat('estimate_k', num2str(k), '.mat');
  save(sname, 'I1', 'I2');
end
