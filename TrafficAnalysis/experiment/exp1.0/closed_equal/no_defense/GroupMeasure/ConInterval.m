function [st,ed] = ConInterval(ent_summary)

size = length(ent_summary);
ent_collect = [];

for i = 1:size
    if i ~= 1           % donot collect first one, which is the direct measure
        ent_collect = [ent_collect, mean(ent_summary{i})];
    end
end



ent_sort = sort(ent_collect);


ed = log2(99) - ent_sort(3);
st = log2(99) - ent_sort(48);

end