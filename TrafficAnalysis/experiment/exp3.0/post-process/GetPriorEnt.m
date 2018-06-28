function ent = GetPriorEnt(arg1, isOpenworld)
if nargin >= 1
    % specify path
    
    p = importdata(arg1);

   
    if isOpenworld == 1 
        % openworld
        prob_m = p.prior(p.mflag == 1);
        prob_nm = sum( p.prior(p.mflag == 0) );
        
        prob_list = [prob_m, prob_nm];
        ent = calEnt(prob_list);
    else
        % closed world
        ent = calEnt(p);
    end

    
else
    % only allow closed world for default, backward compatible
    p = importdata('../jobrecord/prior.mat');
    ent = calEnt(p);
end



end



function ent = calEnt(prob_indiv)

ent = 0; 
num = length(prob_indiv);
for i = 1:num
    if prob_indiv(i) ~= 0
        ent = ent - prob_indiv(i) * log2( prob_indiv(i) );
    end        
end

end





