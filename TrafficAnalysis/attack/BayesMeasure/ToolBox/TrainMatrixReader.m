classdef TrainMatrixReader < handle
    properties
        TrainMatrix
        Label
    end

    methods
        function obj = TrainMatrixReader(data_dir, st, ed)
            obj.TrainMatrix = [];
            obj.Label = [];
            % if .mat exists
            pathmat1 = strcat(data_dir, 'TrainMatrix.mat');
            pathmat2 = strcat(data_dir, 'Label.mat');
            if exist(pathmat1, 'file') == 2 && exist(pathmat2, 'file') == 2
                obj.TrainMatrix = importdata(pathmat1);
                obj.Label = importdata(pathmat2);
            else
            
                % no .mat exists
                lab_count = 1;
                for i = st:ed
                    i
                    pathcsv = strcat(data_dir, int2str(i), '_train.csv');
                    if exist(pathcsv, 'file') == 2
                        matrix = importdata(pathcsv, ' ');
                        r = size(matrix,1);
                        for each_row = 1:r
                            obj.TrainMatrix = [obj.TrainMatrix;matrix(each_row,:)];
                            obj.Label = [obj.Label; lab_count];
                        end
                        lab_count = lab_count + 1;
                        
                    else
                        disp(['no training data for', num2str(i)]);
        
                    end
                end
                % save TrainMatrix, Label
                tempa = obj.TrainMatrix;
                tempb = obj.Label;
                save(pathmat1, 'tempa');
                save(pathmat2, 'tempb');
                
            end

        end
    end
end