function ent_list = EntList(feature_num)
ent_list = zeros(feature_num, 1);


for i = 1:feature_num
    pathname = strcat('ent_', int2str(i), '.mat');
    if exist(pathname) ~= 0
        load(pathname);
        ent_list(i) = log2(99) - mean(x);
        clear x;
    end
end


% plot
plot(1:feature_num, ent_list);


end