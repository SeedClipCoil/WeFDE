function var_list = itself_vs_variation(info_list, findex)

feature_mean = [];
var_list = [];

for i = 1:99 
    temp = info_list{findex}.WebsiteList{i}.original_raw_data(:,findex);
    feature_mean = [feature_mean, mean(temp)];
    
    var_list = [var_list, var(info_list{findex}.WebsiteList{i}.model{1})];
end


plot(feature_mean, var_list, 'r');

end