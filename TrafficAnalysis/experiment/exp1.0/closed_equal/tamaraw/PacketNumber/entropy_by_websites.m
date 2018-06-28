function res = entropy_by_websites(x, mc)

x = log2(99) - x;
res = [];

for i = 0:98
    st = 1 + i*mc;
    ed = mc + i*mc;
    res = [res, mean( x(st:ed) )];
end




end