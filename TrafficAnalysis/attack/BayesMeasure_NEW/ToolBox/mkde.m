function model = mkde(data)
dim = size(data,1);
bandwidth = [];

for each_dim = 1:dim        % calculate bandwidth
    FeatureSample = data(each_dim,:);
    bw = 0.9 * min(std(FeatureSample),iqr(FeatureSample)/1.34)*length(FeatureSample)^(-0.2);
    if bw == 0
        bw = 0.1;
    end
    bandwidth = [bandwidth;bw];
end

model = kde(data, bandwidth);



end