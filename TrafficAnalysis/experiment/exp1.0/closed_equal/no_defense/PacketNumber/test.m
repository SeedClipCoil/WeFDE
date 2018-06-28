% % test
% 
% 
% web_mean_2 = [];
% web_mean_3 = [];
% 
% % get web mean packet number
% 
% for i = 1:99
%     
%     temp = info_list{1}.WebsiteList{i}.original_raw_data(:,2);
%     temp = mean(temp);
%     web_mean_2 = [web_mean_2, temp];
%     
%     temp = info_list{1}.WebsiteList{i}.original_raw_data(:,3);
%     temp = mean(temp);
%     web_mean_3 = [web_mean_3, temp];
% 
%     
% end





% x2, x3










num = 100;








per_webx2 = [];
per_webx3 = [];

for i = 0:98
    section = x2(num*i+1:num*i+num);
    per_webx2 = [per_webx2; mean(section)];
    
    section = x3(num*i+1:num*i+num);
    per_webx3 = [per_webx3; mean(section)];

end