% draw, for open world

prm = 0:0.05:1;

ent = [];

points = [0.6643, 0.1]; % prm




for i = prm
    if i ~= 0 && i ~= 1
        temp = -log2(i) * i - log2(1-i) * (1-i);
    else
        temp = 0;
    end
    ent = [ent, temp];
end



plot(prm, ent, 'b');
hold on;


for target = points
    plot(target, -log2(target)*target - log2(1-target)*(1-target), 'r*');
end