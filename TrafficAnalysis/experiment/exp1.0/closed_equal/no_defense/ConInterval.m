function ci = ConInterval(si, ei)
ci = [];

for i = si:ei
    temp_ci = zeros(1,3);
    pathname = strcat('ent_', int2str(i), '.mat');
    load(pathname);
    ent_mean = mean(x,2);
    
    temp_ci(1) = log2(99) - ent_mean(1);
    
    
    ent_mean_sort = sort( ent_mean(2:51) );
    temp_ci(3) = log2(99) - ent_mean_sort(3);
    temp_ci(2) = log2(99) - ent_mean_sort(48);

    ci = [ci;temp_ci];
    
end








end