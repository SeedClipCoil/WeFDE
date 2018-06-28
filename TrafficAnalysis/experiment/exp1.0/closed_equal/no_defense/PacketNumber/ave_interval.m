% test 2

sum = zeros(100,1);
count = zeros(100,1);


collect = cell(20,1);








for i = 1:99
    int = ceil(web_mean_3(i)/500);
    if(int <= 4)
       index = 1;
    elseif (int <= 8)
        index = 2;
    else 
        index = 3;
    end
    collect{index} = [collect{index}, var(info_list{3}.WebsiteList{i}.model{1})];
    sum(index) = sum(index) + per_webx3(i);
    count(index) = count(index) + 1;
end


result = sum./count;
