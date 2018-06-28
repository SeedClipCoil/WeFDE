% model_vector: indicates which features are grouped in
%               modeling/evaluation, start from 1, 0 is ignored
% model:        the pdf model
% raw_data:     the original data instances
% id:           the id of the Websiter



classdef Websiter < handle

    properties
        model_vector
        model
        raw_data
        original_raw_data
        id
    end
    
    methods
        function obj = Websiter(iden, vec, r_data)
            obj.model_vector = vec;
            obj.id = iden;
            obj.original_raw_data = r_data;
            obj.raw_data = obj.original_raw_data;
        end
    

        % model building after eating data 
        function BuildPDF(obj)   
            % build model
            for group = 1:max(obj.model_vector)
                selector = obj.model_vector==group;
                group_data = obj.raw_data(:, selector);
                if sum(selector) == 1
                    % single dimensional KDE
                    obj.model{group} = KernelEstimate(group_data);
                else
                    % multiple dimensional KDE
                    obj.model{group} = mkde(group_data');
                end
            end
        end
    
        % given a instance, return the log of the probability
        function r = Evaluate(obj, instance)
            r = 0;
            temp = sort(obj.model_vector);
            shrink_model_vector = temp(temp ~= 0);
            for group = min(shrink_model_vector):max(shrink_model_vector)
                selector = shrink_model_vector==group;
                group_ins = instance(selector);
                if sum(selector) == 1
                    % single KDE
                    r_temp = log2(pdf(obj.model{group}, group_ins));
                else
                    % multiple KDE
                    r_temp = log2(evaluate(obj.model{group}, group_ins'));
                end
                
                % if r_temp is -inf
                if r_temp == -inf
                    r_temp = -300;
                end
                r = r + r_temp;
            end
        end
        
        % sampling, used for entropy evaluation
        % r is samples corresponding to each group
        function r = Sampling(obj, n)
            r = [];
            for group = 1:max(obj.model_vector)
                selector = obj.model_vector==group;
                if sum(selector) == 1
                    % single variable model
                    temp = random(obj.model{group}, n, 1);
                else
                    % multiple variable model
                    temp = sample(obj.model{group}, n)';
                end
                r = [r, temp];
            end 
        end
        
        % return Mutual Information measure
        function mi = MI(obj, normalize_flag)
            feature_num = size(obj.raw_data,2);
            mi = zeros(feature_num, feature_num);
            for i = 1:feature_num
                for j = i:feature_num
                    compare_data = obj.original_raw_data(:,[i,j]);
                    mi(i,j) = MutualInfo(compare_data');
                    mi(j,i) = mi(i,j);
                end
            end
            % whether normalize
            if normalize_flag == 1
               mi_normalize = zeros(feature_num, feature_num);
               for i = 1:feature_num
                   for j = 1:feature_num
                       temp_max = max( [mi(i,i), mi(j,j)] );
                       if temp_max ~= 0
                           mi_normalize(i,j) = mi(i,j)/temp_max;
                       else 
                           mi_normalize(i,j) = 0;
                       end                                    
                   end
               end
               mi = mi_normalize;
            end
            
        end
        
        % reModel
        function reModel(obj, krate, selector)
            % resample original_raw_data to obtain raw_data
            instance_num = size(obj.original_raw_data, 1);
            
            if selector == 1
            % resample WITH replacement
                r_number = randi(instance_num, instance_num, 1);
            end
            if selector == 2
            % resample WITHOUT replacement 
                k = ceil(instance_num*krate);
                r_number = randsample(instance_num, k);
            end
            obj.raw_data = obj.original_raw_data(r_number, :);
            obj.BuildPDF()
            
        end
        
    end


end
















