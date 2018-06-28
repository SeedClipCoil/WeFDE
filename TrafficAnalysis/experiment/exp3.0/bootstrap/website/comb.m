clear;

addpath('../post-process/');
addpath('../../../attack/MIanalysis/');



infoMatrix = nan(20,15);

selector = GetSelector();

for datasetIdx = 1:20

    for cat = 1:15
        path = strcat('combine/', num2str(datasetIdx-1), '_category', num2str(cat), '_topn', num2str(selector{cat}{2}(end)), '_bstrap0.mat');
        info = JobRecordFusion(path, log2(100));
        infoMatrix(datasetIdx, cat) = info;
    end

end



for cat = 1:15
    [low, high] = ConfidenceInterval(infoMatrix(:,cat), 1);
    plot([cat, cat], [low, high], 'k', 'LineWidth', 2);
    hold on;
end

xlabel('Category Index');
ylabel('Information Leakage (Bit)');