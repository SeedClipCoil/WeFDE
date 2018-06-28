function [st,ed] = ConInterval(ent_bs)

ent_mean = mean(ent_bs,2);

ent_mean_sort = sort(ent_mean);


st = log2(99) - ent_mean_sort(3);
ed = log2(99) - ent_mean_sort(48);

end