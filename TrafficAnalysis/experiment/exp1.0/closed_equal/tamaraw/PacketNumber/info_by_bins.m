function bins_info = info_by_bins(info_list, findex)

padL = 100;
web_num = 99;

bins_info = [];


for bins = padL:padL:30000
    log_prob = zeros(1,web_num);
    for i = 1:web_num
        log_prob(i) = info_list{findex}.WebsiteList{i}.Evaluate(bins);
    end
    bins_info = [bins_info, Entropy(log_prob)];
end


end