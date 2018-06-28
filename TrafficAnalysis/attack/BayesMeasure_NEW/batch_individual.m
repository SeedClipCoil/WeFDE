% individual batch
clear;
bitset = 1:43;
parfor_progress(length(bitset)*51);

for i =bitset
    vec = zeros(1,43);
    vec(i) = 1;
    open_world(vec,i);
end

parfor_progress(0);