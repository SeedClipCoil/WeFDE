function Combine(findex)
% combine to get "ent_summary_" struct

pool_path = strcat('web_pool_', int2str(findex), '.mat');
pool = importdata(pool_path);
web_num = length(pool);

ent_summary = cell(1,web_num);
for i = 1:web_num
    path_temp = strcat('f', int2str(findex), '-w', int2str(i), '.mat');
    temp = importdata(path_temp);
    ent_summary{i} = temp{i};
end

savepath = strcat('ent_summary_', int2str(findex), '.mat');
save(savepath, 'ent_summary');

end