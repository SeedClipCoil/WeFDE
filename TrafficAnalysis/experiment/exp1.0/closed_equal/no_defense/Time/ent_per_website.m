% ent mean for per website


function out = ent_per_website(ent)

mc_sum = 100;

out = [];
for i = 0:98
    temp = ent(i*mc_sum+1 : i*mc_sum + mc_sum);
    out = [out, mean(temp)];
end



end