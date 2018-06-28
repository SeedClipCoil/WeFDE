function out = infoleak_per_category(ent_summary)
out = [];

for i = 1 : length(ent_summary)
    out = [out, log2(99) - mean(ent_summary{i})];
end

end