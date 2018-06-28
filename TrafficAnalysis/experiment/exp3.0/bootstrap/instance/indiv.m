clear;

addpath('../../post-process/');

rdata = load('../../no_defense/info/top100/combine_measure/MIanalysis/MIanalysis_cat1_topn100.mat');

flist = rdata.topnFeatureList;


infoMatrix = nan(21,length(flist));



for iter = 0:20

    for fidx = 1:length(flist)
        path = strcat('individual/JobRecord_top100_fidx', num2str(flist(fidx)), '_iter', num2str(iter), '.mat');
        info = JobRecordFusion(path, log2(100));
        infoMatrix(iter+1, fidx) = info;
    end

end



for fidx = 1:100
    [low, high] = ConfidenceInterval(infoMatrix(:,fidx), 1);
    plot([fidx, fidx], [low, high], 'k', 'LineWidth', 2);
    hold on;
    
end

xlabel('Top 100 Most Informative Features (indexed by rank)');
ylabel('Information Leakage (Bit)');
