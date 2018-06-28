addpath('../../../post-process/');
addpath('../../../../../attack/InfoMeasure/parallel_measure/');
addpath('../../../../../attack/MIanalysis/');





ent_ave_path = strcat('../../info/top100/individual_measure/results/ave_entropy.mat');

ent_ave = importdata(ent_ave_path);
[ord_ent, idx] = sort(ent_ave,'descend');



mi_matrix_path = '../../info/top100/combine_measure/MIanalysis/MIanalysis_mi.mat';
mi_matrix = importdata(mi_matrix_path);

top100_mi = mi_matrix(idx(1:100), idx(1:100));



mapp = [];
for i = 1:1:90
    mapp = [mapp; 1, 1 - i*0.01, 1 - i*0.01];
end

colormap(mapp);



imagesc(top100_mi);
%imshow(top100_mi);
xlabel('the Top 100 Most Informative Features', 'FontSize', 14);
ylabel('the Top 100 Most Informative Features', 'FontSize', 14);
h = colorbar;
set(h, 'ylim', [0 0.95])





%%%% calculate redandent features in top100

red_idx = zeros(1,100);


for i = 1:100
    if red_idx(i) ~= 0
        % has been pruned or represented
        continue;
    end
    
    % not represented, search for duplication
    for j = (i+1):100
        if top100_mi(i,j) > 0.9
            % find a redundant
            red_idx(j) = i;
        end
    end
end






