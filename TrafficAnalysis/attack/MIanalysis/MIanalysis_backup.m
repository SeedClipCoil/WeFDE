% three steps to reduce the features' dimensions
% step 1: cover duplicated features, done in FeatureSelector()
% step 2: Eliminate high MI, done in GenerateVec()
% step 3: group by mutual information matrix
classdef MIanalysis < handle
    properties
        ent
        dataset_path
        % MI matrix (max_n)
        MI
        fidx
        fidx_sort
        
        % MI matrix (topm)
        MI_topm
        fidx_topm
        
        % prune (eliminate high MI features)
        MI_topm_prune
        fidx_topm_prune
        

        % generated vec
        vec
        cluster_idx
    end

    
    methods

        %%%%%% external interface
        
        function obj = MIanalysis(dataset_path)
            obj.dataset_path = dataset_path;
        end
        
         
        function SelectFeatures(obj, ent, candidate_list, max_n)
            obj.ent = ent;
            
            if length(candidate_list) == length(ent)
                % an overall measurement, cover duplicate features
                candidate_list = obj.CoverDuplicate();
            end
            
            candidate_ent = ent(candidate_list);
            [arr, i] = sort(candidate_ent, 'descend');
            candidate_list_sort = candidate_list(i);
            obj.fidx_sort = candidate_list_sort(1:max_n);
            obj.fidx = sort(obj.fidx_sort);
        end
        
        function PairwiseMI(obj) 
            % construct Info structure
            reader_monitor = TrainMatrixReader(obj.dataset_path);
            Tmatrix{1} = reader_monitor.TrainMatrix;
            label{1} = reader_monitor.Label;
       
            prior = PriorWebsites('Closed_World_Equal', reader_monitor.Rank);
            vec = zeros(1, 3043);
            vec(obj.fidx) = 1;
            
            info = EvaluatorMachine(Tmatrix, label, vec, prior);
            obj.MI = info.MI(1);
        end
       
        
        function MItopm(obj, topm) 
            % pick topm features in obj.feature_list
            fidx_topm = sort( obj.fidx_sort(1:topm) );
            idxMapFeature = obj.fidx;
            
            midx_topm = [];
            for i = 1:length(fidx_topm)
                fid = fidx_topm(i);
                for j = 1:length(idxMapFeature)
                    if idxMapFeature(j) == fid
                        midx_topm = [midx_topm, j];
                        break;
                    end
                end
                
            end
            
            obj.MI_topm = obj.MI(midx_topm, midx_topm);
            obj.fidx_topm = fidx_topm;
        end
        
         
        
        % overall measurement: eliminate the duplicate
        function candidate_list = CoverDuplicate(obj)
            
            % use selector for elimiating duplicate features
            selector = zeros(1, length(obj.ent)) + 1;
            
            % in calculating total: cover duplicated features
            selector(2940:2943) = 0;        % cumul: incoming/outgoing packet number
            selector(2939) = 0;             % PktSec: sum of packets from each bucket equals to total packet number
            selector(3043) = 0;             % cumul: the last interpolation
            selector(2993) = 0;             % cumul: the last interpolation
            
            mylist = 1:length(obj.ent);
            candidate_list = mylist(selector==1);
        end
        
        
        function EliminateHighMI(obj, MI_THRES)
            feature_num = size(obj.MI_topm, 1);
            
            % index in MI_topm
            high_MI = [];
            for i = 1:feature_num
                % if i in high_MI, skip
                if sum( high_MI == i ) ~= 0
                    continue;
                end
                
                % then i not in high_MI
                for j = (i+1):feature_num
                    if obj.MI_topm(i,j) > MI_THRES && sum( high_MI==j ) == 0
                        % high MI, while not included
                        high_MI = [high_MI, j];
                    end
                end
            end
            
            % update MI_raw and idx_raw
            obj.fidx_topm_prune = obj.fidx_topm;
            obj.fidx_topm_prune(high_MI) = [];
            
            obj.MI_topm_prune = obj.MI_topm;
            obj.MI_topm_prune(high_MI,:) = [];
            obj.MI_topm_prune(:,high_MI) = [];
            
        end
        
        % DBSCAN
        function vec = GroupByMI(obj, DBSCAN_THRES)
            % 
            new = 1 - obj.MI_topm_prune;
            cluster_idx = DBSCAN(new, DBSCAN_THRES, 1);
            vec = zeros(1,length(obj.ent));
            vec(obj.fidx_topm_prune) = cluster_idx;
            obj.vec = vec;
            obj.cluster_idx = cluster_idx;
        
        end
        
    end
    
    
    
end
