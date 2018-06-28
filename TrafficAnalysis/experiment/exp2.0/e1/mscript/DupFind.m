function eq = DupFind(feature) 
num_feature = length(feature);

eq = cell(1, num_feature);

parfor i = 1: num_feature
    i
    original = feature(i);
    for j = (i+1) : num_feature
        dst = feature(j);
        if original == dst
            eq{i} = [eq{i};i,j];
        end
    end
end


end