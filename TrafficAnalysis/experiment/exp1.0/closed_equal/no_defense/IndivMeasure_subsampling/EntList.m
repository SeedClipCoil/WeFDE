function ent_list = EntList(web_num)
ent_list = zeros(web_num, 1);


for i = 1:web_num
    pathname = strcat('ent_', int2str(i), '.mat');
    if exist(pathname) ~= 0
        load(pathname);
        ent_list(i) = log2(99) - mean(x);
        clear x;
    end
end



end