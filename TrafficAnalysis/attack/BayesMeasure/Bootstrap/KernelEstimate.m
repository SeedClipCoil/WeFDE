function output = KernelEstimate(FeatureMatrix)

FeatureNum = length(FeatureMatrix(1,:));
pdf_set = [];

for i = 1:FeatureNum
    if mod(i,100) == 0
        i;
    end
    FeatureSample = FeatureMatrix(:,i);
    bandwidth1 = 0.9 * min( std(FeatureSample), iqr(FeatureSample)/1.34 ) * length(FeatureSample)^(-0.2);

    bandwidth2 = 1.06 * std(FeatureSample) * length(FeatureSample)^(-0.2);
    %bandwidth = 50;
    
    if bandwidth1 ~= 0
        pdf = fitdist(FeatureSample,'Kernel','BandWidth',bandwidth1, 'Kernel', 'normal');
    elseif bandwidth2 ~= 0 
        pdf = fitdist(FeatureSample,'Kernel','BandWidth',bandwidth2, 'Kernel', 'normal');
    else
        pdf = fitdist(FeatureSample,'Kernel','BandWidth', 1, 'Kernel', 'normal');
    end
    
    pdf_set = [pdf_set, pdf];
end

output = pdf_set;

end
