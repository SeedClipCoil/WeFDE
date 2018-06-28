% serial draw


for i = 1:99
    if(web_mean_3(i) > 4000)
        drawdis(info_list{3}.WebsiteList{i}.model{1}, 4000, 20000, 'r');
        hold on;
    end
end