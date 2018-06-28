clear;

addpath('../post-process/');

rdata = load('../no_defense/info/top2000/combine_measure/MIanalysis/MIanalysis_cat1_topn100.mat');

flist = rdata.topnFeatureList;


infoMatrix = nan(20,length(flist));



for datasetIdx = 1:20

    for fidx = 1:length(flist)
        path = strcat('individual/JobRecord_', num2str(datasetIdx-1), '_fidx', num2str(flist(fidx)), '_iter1.mat');
        info = JobRecordFusion(path, log2(100));
        infoMatrix(datasetIdx, fidx) = info;
    end

end



for fidx = 1:100
    [low, high] = ConfidenceInterval(infoMatrix(:,fidx), 1);
    plot([fidx, fidx], [low, high], 'k', 'LineWidth', 2);
    hold on;
    
end

xlabel('Top 100 Most Informative Features (indexed by rank)');
ylabel('Information Leakage (Bit)');
