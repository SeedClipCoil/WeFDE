% individual batch
function batch_individual_open(st,ed)

bitset = st:ed;
%parfor_progress(length(bitset)*21);

for i =bitset
    vec = zeros(1,43);
    vec(i) = 1;
    open_world(vec,i);
end

%parfor_progress(0);
end