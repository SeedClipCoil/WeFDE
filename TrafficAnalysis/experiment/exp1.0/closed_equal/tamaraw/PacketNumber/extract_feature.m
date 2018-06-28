function x = extract_feature(info_list, findex)

x= cell(1,99);   % feature

for i = 1:99
    x{i} = info_list{findex}.WebsiteList{i}.original_raw_data(:,findex);
    
end


end
