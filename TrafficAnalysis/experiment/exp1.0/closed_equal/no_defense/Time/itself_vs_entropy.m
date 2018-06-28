function x = itself_vs_entropy(ent_list, info_list, findex)

x= [];   % feature
y = [];  % ent

for i = 1:99
    temp1 = info_list{findex}.WebsiteList{i}.original_raw_data(:,findex);
    x = [x, mean(temp1)];
    y = [y, ent_list(i)];
end

plot(x,y,'r');

end