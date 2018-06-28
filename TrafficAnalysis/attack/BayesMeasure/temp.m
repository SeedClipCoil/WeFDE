% temp: to draw generic PDF

i = 0; 
j = 15000;


x = i:5:j;

y = 0;
for website = 1:99
    wpdf = info_list{1}.WebsiteList{website}.model{1};
    y = y + pdf(wpdf,x)/99;
end
plot(x,y,'r');