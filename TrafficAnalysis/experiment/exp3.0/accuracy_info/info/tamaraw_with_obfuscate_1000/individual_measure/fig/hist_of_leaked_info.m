% histgram of features' leaked information (in bit)

% load data
ave = importdata('../results/entropy.mat');

[counts,xx] = hist(ave, 0.1:0.2:4);
perc = counts/sum(counts)*100;

bar(xx, perc, 1, 'r');

axis([0 4 0 50]);

% set x/y label
xlabel('Leaked Information (Bit)', 'FontSize', 14);
ylabel('Percentage of Features', 'FontSize', 14);
  