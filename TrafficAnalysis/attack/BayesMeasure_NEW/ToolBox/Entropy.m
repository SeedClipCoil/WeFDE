function ent = Entropy(prob_set, prior, Mflag)
% calculate the entropy: the unit of entropy is Shannon, means log_2 this 
% unit of entropy are also commonly referred to as, bits

% prob_set: log2 of the probabilities


prob_set = prob_set - max(prob_set);
prob_set = 2.^prob_set;


prob_temp = prob_set .* prior;
prob_indiv = prob_temp / sum(prob_temp);


% check: probabilities is summed to be 1
if sum(prob_indiv) < 0.99
    disp('erorr in Entropy: sum of probabilities is not 1');
end


% calculate entropy
ent = 0;
if( sum(Mflag == 0) == 0)
    % closed world
    num = length(prob_indiv);
    for i = 1:num
        if prob_indiv(i) ~= 0
            ent = ent - prob_indiv(i) * log2( prob_indiv(i) );
        end        
    end
else
    % open world
    prob_m = sum( prob_indiv(Mflag == 1) );
    prob_nm = sum( prob_indiv(Mflag == 0) );
    
    if prob_m ~= 0 && prob_nm ~= 0
       ent = ent - prob_m * log2(prob_m) - prob_nm * log2(prob_nm);
    end
    
end


end
