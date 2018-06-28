function res = KL_Divergence(prob_set, st_prior, ed_prior, Mflag)
% calculate the entropy: the unit of entropy is Shannon, means log_2 this 
% unit of entropy are also commonly referred to as, bits

% prob_set: log2 of the probabilities


% only look at non-monitored
prob_set = prob_set(Mflag == 0);
st_prior = st_prior(Mflag == 0);
ed_prior = ed_prior(Mflag == 0);

% make st_prior, ed_prior to be 1
st_prior = st_prior/sum(st_prior);
ed_prior = ed_prior/sum(ed_prior);


prob_set = prob_set - max(prob_set);
prob_set = 2.^prob_set;

upper = prob_set .* st_prior;
lower = prob_set .* ed_prior;

res = log2( sum(upper)/sum(lower) );


end
