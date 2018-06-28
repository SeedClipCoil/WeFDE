% plot

function plotExplained(explained)

elen = length(explained);

x = [];
y = [];

for compnum = 1:elen
    x = [x, compnum];
    y = [y, sum(explained(1:compnum))];
end


plot(x,y);

end