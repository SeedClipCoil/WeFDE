function [ci_low, ci_high] = ConfidenceInterval(results, eachtail)


num = length(results);
ordered = sort(results);


ci_low = ordered(1+eachtail);
ci_high = ordered(num-eachtail);
end