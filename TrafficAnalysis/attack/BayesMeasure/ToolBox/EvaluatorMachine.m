classdef EvaluatorMachine < handle
    
    properties
        WebsiteList
        model_vector
        
        SampleList
        SampleListLabel
        feature_num
    end
    
    methods
        function obj = EvaluatorMachine(TrainMatrix, Label, vec)
            obj.model_vector = vec;
            obj.feature_num = size(TrainMatrix,2);
            for id = min(Label):max(Label)
                %id
                web_data = TrainMatrix(Label==id,:);
                obj.WebsiteList{id} = Websiter(id, vec, web_data);
                obj.WebsiteList{id}.BuildPDF();
            end
        end
        
        % evaluate the entropy of Samples
        function ent = Evaluate(obj)
            num_instance = size(obj.SampleList,1);
            num_web = length(obj.WebsiteList);
            
            ent = zeros(1,num_instance);
            for each_inst = 1:num_instance
                %each_inst
                % each instance
                log_prob = zeros(1,num_web);
                for each_web = 1:num_web
                    log_prob(each_web) = obj.WebsiteList{each_web}.Evaluate(obj.SampleList(each_inst,:));
                end
                ent(each_inst) = Entropy(log_prob);
            end
            
        end
        
        function [prob_summary, right, wrong] = ClassifySimulator(obj)
            num_instance = size(obj.SampleList,1);
            num_web = length(obj.WebsiteList);
            
            prob_summary = [];
            right = 0;
            wrong = 0;
            for each_inst = 1:num_instance
                each_inst
                % each instance
                log_prob = zeros(1,num_web);
                for each_web = 1:num_web
                    log_prob(each_web) = obj.WebsiteList{each_web}.Evaluate(obj.SampleList(each_inst,:));
                end
                prob_summary = [prob_summary; log_prob];
                [m,i] = max(log_prob);
                if i == obj.SampleListLabel(each_inst)
                    right = right + 1;
                else 
                    wrong = wrong + 1;
                end
                
            end
        end
        
        
        % Generate Samples, for Evaluate function
        function GenerateSamples(obj, num)
            obj.SampleList = [];
            obj.SampleListLabel = [];
            web_num = length(obj.WebsiteList);
            for id = 1:web_num
                obj.SampleList = [obj.SampleList; obj.WebsiteList{id}.Sampling(num)];
                obj.SampleListLabel = [obj.SampleListLabel; id];
            end
        end
        
        % return averaged mutual information matrix
        function mi = MI(obj, normalize_flag)
            mi = zeros(obj.feature_num, obj.feature_num);
            web_num = length(obj.WebsiteList);
            for i = 1:web_num
                temp = obj.WebsiteList{i}.MI(normalize_flag);
                mi = mi + temp;
            end
            mi = mi./web_num;           
        end
        
        % reModel: for bootstrap
        function reModel(obj, krate, selector)
            web_num = length(obj.WebsiteList);
            for id = 1:web_num
                obj.WebsiteList{id}.reModel(krate, selector);
            end
        end
        
        
    end    
    
end



