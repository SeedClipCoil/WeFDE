function res = Consistency(findex)
% consistency check
% for FastDirect_open_world
DIRECTORY = 'category/';
res = 1;

path_pool = strcat(DIRECTORY, 'web_pool_', int2str(findex), '.mat');
pool = importdata(path_pool);

web_num = length(pool);

new_pool = zeros(1,web_num) + 1;

for i = 1:web_num
    path = strcat(DIRECTORY, 'f', int2str(findex), '-w', int2str(i), '.mat');
    if exist(path) ~= 2
        new_pool(i) = 0;
        res = 0;
    end
end


% output new pool
save(path_pool, 'new_pool');



end






