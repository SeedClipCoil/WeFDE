function prob = zipf(rank)

% rank: array containing rank info
% return: the probability for each rank (summation = 1)


indiv = [];

for i = 1:length(rank)
    indiv = [indiv, rank(i)^(-1)];
end

prob = indiv./sum(indiv);




end