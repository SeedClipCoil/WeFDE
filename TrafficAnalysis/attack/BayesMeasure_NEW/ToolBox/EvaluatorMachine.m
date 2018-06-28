classdef EvaluatorMachine < handle
    
    properties
        WebsiteList
        MonitorFlag
        prior
        
        model_vector
        
        SampleList
        SampleNum
        
        feature_num
        IsOpenWorld
        
    end
    
    methods
        % TrainMatrix and Label be cell
        function obj = EvaluatorMachine(TrainMatrix, Label, vec, websites_prior)
            %display('Construct EvaluatorMachine');
            obj.model_vector = vec;
            obj.feature_num = size(TrainMatrix{1},2);
            obj.prior = websites_prior;
            % no matter closed/open, at least have cell 1 for TrainMatrix
            % and Label
            for l = min(Label{1}):max(Label{1})
                %id
                id = l;
                web_data = TrainMatrix{1}(Label{1}==l,:);
                obj.WebsiteList{id} = Websiter(id, vec, web_data);
                obj.MonitorFlag(id) = 1;
                obj.WebsiteList{id}.BuildPDF();
            end
            
            % if open world
            if length(Label) == 2
                obj.IsOpenWorld = 1;
                id_close = id;
                for l = min(Label{2}):max(Label{2})
                    id = id_close + l;
                    web_data = TrainMatrix{2}(Label{2}==l,:);
                    obj.WebsiteList{id} = Websiter(id, vec, web_data);
                    obj.MonitorFlag(id) = 0;
                    obj.WebsiteList{id}.BuildPDF(); 
                end
            else
                obj.IsOpenWorld = 0;
            end
            
        end
        
        % evaluate the entropy of Samples
        % webIdx = 0:       evaluate all
        % otherwise:        evaluate webIdx website
        function whole_ent = Evaluate(obj, webIdx)
            
            %display('Start Evaluate Samples...');
            web_num = length(obj.SampleList); 
            whole_ent = cell(1, web_num);            
            
            if webIdx == 0 
                Evalist = 1:web_num;
            else
                Evalist = webIdx;
            end
            
            for wi = Evalist 
                %disp(['Evaluate Samples from Website ', int2str(wi)]);
                % get number of instances for each web
                num_inst = size(obj.SampleList{wi}, 1);
                web_ent = zeros(num_inst, 1);
                
                for each_inst = 1:num_inst
                    % each instance
                    log_prob = zeros(1, web_num);
                    for each_web = 1:web_num
                        log_prob(each_web) = obj.WebsiteList{each_web}.Evaluate(obj.SampleList{wi}(each_inst,:));
                    end
                    
                    % translate log probabilities into entropy
                    web_ent(each_inst) = Entropy(log_prob, obj.prior, obj.MonitorFlag);
                end
                whole_ent{wi} = web_ent;
            end
            
        end
        
        
        
        % Generate Samples, for Evaluate function
        % num:  total sample number, the true number may be more
        function GenerateSamples(obj, TotalNum)
            %display('Generate Samples');
            web_num = length(obj.WebsiteList);
            obj.SampleList = cell(web_num, 1);
            for id = 1:web_num
                per_num = ceil( TotalNum*obj.prior(id) );
                obj.SampleList{id} = obj.WebsiteList{id}.Sampling(per_num);
            end
        end
        
        % set samples directly
        function SetSampleList(obj, MySamples)
            obj.SampleList = MySamples;
        end
        
        % get samples: return obj.SampleList
        function Res = GetSampleList(obj)
            Res = obj.SampleList;
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
        
        % reModel: for bootstrap/subsampling
        function reModel(obj, krate, selector)
            web_num = length(obj.WebsiteList);
            for id = 1:web_num
                obj.WebsiteList{id}.reModel(krate, selector);
            end
        end
        
        
    end    
    
end



