function x = ave_by_websites(info_list, findex)

x= [];   % feature

for i = 1:99
    temp = info_list{findex}.WebsiteList{i}.original_raw_data(:,findex);
    x = [x, mean(temp)];
end


end
