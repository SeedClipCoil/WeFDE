% a simulation on range of info vs. accuracy


web_num = 100;
alpha = 0.01:0.01:0.9;

upper = zeros(1,length(alpha)) + log2(web_num);


for i = 1:length(alpha)
    acc = alpha(i);
    ma(i) = log2(web_num) + acc*log2(acc) + (1-acc)*log2(1-acc);
    mi(i) = log2(web_num) + acc*log2(acc) + (1-acc)*log2( (1-acc)/(web_num-1) );
end



plot(alpha, upper, '--k');
hold on;
plot(alpha, ma, 'r');
plot(alpha, mi, 'b');
%axis([0, 1, 0, 8]);

xlabel('Accuracy \alpha');
ylabel('Infomation Leakage (Bit)');

legend('Generic Upper Bound of Information Leakage', 'Max of Information Leakage', 'Min of Information Leakage', 'Position', [200 220 1 1]);

