% drawing, basically 

anonymity_set = 1:100;

ent = zeros(1,length(anonymity_set));

target = 5.2772;
ind = 1;
dist = 10000;


for i = anonymity_set
    ent(i) = log2(i);
    if abs(log2(i) - target) < dist
        dist = abs(log2(i) - target);
        ind = i;
    end
end



plot(anonymity_set, ent, 'b');

hold on;
plot(ind, ent(ind), 'r*');
plot(99, ent(99), 'r*');