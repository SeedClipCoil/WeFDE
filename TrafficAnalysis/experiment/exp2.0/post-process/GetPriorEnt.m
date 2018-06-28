function ent = GetPriorEnt()
prior = importdata('../jobrecord/prior.mat');
num = length(prior);
ent = 0;

for i = 1:num
    if prior(i) ~= 0
        ent = ent - prior(i) * log2(prior(i));
    end
end
end