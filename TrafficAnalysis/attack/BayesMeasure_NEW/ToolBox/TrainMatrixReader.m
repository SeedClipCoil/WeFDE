classdef TrainMatrixReader < handle
    properties
        TrainMatrix
        Label
        Rank
    end

    methods
        
        % st, ed denote the start and end for rank
        function obj = TrainMatrixReader(data_dir)
            obj.TrainMatrix = [];
            obj.Label = [];
            obj.Rank = [];
            % if .mat exists
            pathmat1 = strcat(data_dir, 'TrainMatrix.mat');
            pathmat2 = strcat(data_dir, 'Label.mat');
            pathmat3 = strcat(data_dir, 'Rank.mat');
            if exist(pathmat1, 'file') == 2 && exist(pathmat2, 'file') == 2 && exist(pathmat3, 'file') == 2
                obj.TrainMatrix = importdata(pathmat1);
                obj.Label = importdata(pathmat2);
                obj.Rank = importdata(pathmat3);
            else
            
                % no .mat exists
                lab_count = 1;
                
                % list dir 
                filelist = dir(data_dir);
                
                % skip the first 2 ('.' and '..')
                for i = 3:length(filelist)
                    
                    pathcsv = strcat(data_dir, filelist(i).name);
                    if exist(pathcsv, 'file') == 2
                        matrix = importdata(pathcsv, ' ');
                        r = size(matrix,1);
                        for each_row = 1:r
                            obj.TrainMatrix = [obj.TrainMatrix;matrix(each_row,:)];
                            obj.Label = [obj.Label; lab_count];
                        end
                        lab_count = lab_count + 1;
                        % extract rank
                        sp = strsplit(filelist(i).name, '_');
                        
                        obj.Rank = [obj.Rank; str2num(sp{1})];
                        
                    else
                        %disp(['no training data for', num2str(i)]);
        
                    end
                end
                % save TrainMatrix, Label
                tempa = obj.TrainMatrix;
                tempb = obj.Label;
                tempc = obj.Rank;
                save(pathmat1, 'tempa');
                save(pathmat2, 'tempb');
                save(pathmat3, 'tempc');
            end

        end
    end
end
