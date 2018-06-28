% measure the mutual infomation (MI) between two features
clear;
[TrainMatrix,Label1] = TrainMatrixRead(0,99);
[ins_number, fea_num] = size(TrainMatrix);

% mi matrix
MI = zeros(200,fea_num,fea_num) + inf;

version1 = zeros(fea_num,fea_num);
counter = 0;
for each_website = min(Label1):max(Label1)
    
    each_website
    each_data = TrainMatrix(Label1==each_website,:);
     
     % check whether data is empty
    if isempty(each_data) == 1
        continue;
    end
     
     % for each feature, compute MI
    for each_f1 = 1:fea_num
        temp_data = each_data(:,[each_f1,each_f1]);
        floor = MutualInfo(temp_data');
        for each_f2 = each_f1:fea_num
            temp_data = each_data(:,[each_f1,each_f2]);
            % a feature is constant
            if floor == 0
                MI(each_website,each_f1,each_f2) = 0;
                MI(each_website,each_f2,each_f1) = 0;

            else
                MI(each_website,each_f1,each_f2) = MutualInfo(temp_data')/floor;
                MI(each_website,each_f2,each_f1) = MutualInfo(temp_data')/floor;

            end
        end
    end
    
    version1 = version1 + squeeze(MI(each_website, :, :));
    counter = counter + 1;


end

version1 = version1/counter;




