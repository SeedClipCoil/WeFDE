function [res, idx] = topnPrior(rank, mflag, topn)
% non-monitor topn considered, the prior therefore

webNum = length(rank);
idx = [];

for wi = 1 : webNum
  if mflag(wi) == 1
    % monitored one
    topn_rank(wi) = rank(wi);
  else
    % non-monitored
    if rank(wi) <= topn
      % within topn
      topn_rank(wi) = rank(wi);
      idx = [idx, wi];
    else
      % out of topn
      topn_rank(wi) = 0;
    end  

  end
    
end 


res = zipf(topn_rank);


end
