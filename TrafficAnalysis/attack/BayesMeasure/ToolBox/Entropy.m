function ent = Entropy(prob_set)
% calculate the entropy: the unit of entropy is Shannon, means log_2 this 
% unit of entropy are also commonly referred to as, bits

% prob_set: log2 of the probabilities


prob_set = prob_set - max(prob_set);

prob_set = 2.^prob_set;

probabilities = prob_set/sum(prob_set);


% check: probabilities is summed to be 1
if sum(probabilities) < 0.99
    disp('erorr in Entropy: sum of probabilities is not 1');
end

% calculate the entropy

% the number of websites
WebsiteNum = length(probabilities);

ent = 0;
for each_web = 1:WebsiteNum
    
    % the probability: p( yi |x)
    prob_web = probabilities(each_web);
    if prob_web ~= 0
        ent = ent - prob_web * log2(prob_web);
    end
    
end


end
