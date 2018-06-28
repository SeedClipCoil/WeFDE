% draw variation vs packet number 

packet_number = [];
variation = [];

for i = 1:99
    packet_number = [packet_number, web_mean_2(i)];
    variation = [variation, var(info_list{2}.WebsiteList{i}.model{1})];
end

hold on;
plot(packet_number, variation);