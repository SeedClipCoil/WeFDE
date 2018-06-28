function ave = JobRecordFusion(jm_path, prior_ent)
% given a job manager, give the average of its value

jm = importdata(jm_path);



total = 0;
num = 0;
for i = 1:length(jm.JobResults)
    % for each cell in jm
    % JobResults are the H(C|F)
    % I = H(C) - H(C|F)
    
    total = total + sum( prior_ent - jm.JobResults{i} );
    num = num + length( jm.JobResults{i} );
end

ave = total/num;


end




