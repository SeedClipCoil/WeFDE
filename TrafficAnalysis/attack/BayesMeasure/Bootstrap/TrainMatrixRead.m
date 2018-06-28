function [matrix,label] = TrainMatrixRead(p, q)

matrix = [];
label = [];
for i = p : q
    % import data i
    delimiterIn = ' ';
    pathcsv = strcat('../data/', int2str(i), '_train', '.csv');
    
    if exist(pathcsv, 'file') == 2
        FeatureMatrix = importdata(pathcsv, delimiterIn);
        [r,c] = size(FeatureMatrix);
        for each_row = 1:r
            matrix = [matrix;FeatureMatrix(each_row,:)];
            label = [label; i];
        end
    else
        disp(['no training data for', num2str(i)]);
        
    end
            
end

label = label + 1;
end