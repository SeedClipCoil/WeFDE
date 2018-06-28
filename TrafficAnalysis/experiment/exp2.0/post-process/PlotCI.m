% plot confidence internval
function PlotCI(x,y,bstrap)


ci_low = [];
ci_high = [];

for i = 1:length(x)
    [l,h] = ConfidenceInterval(bstrap{i}, 1);
    ci_low = [ci_low, l];
    ci_high = [ci_high, h];
end


plot(x, y, '.b');
hold on;
errorbar(x, y, y-ci_low, ci_high-y, ':r');

 %set(gca,'xscale','log');

end