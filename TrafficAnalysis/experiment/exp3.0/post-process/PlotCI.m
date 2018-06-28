% plot confidence internval
function PlotCI(x,bstrap,plotArg)


ci_low = [];
ci_high = [];

for i = 1:length(x)
    [l,h] = ConfidenceInterval(bstrap{i}(2:end), 1);
    ci_low = [ci_low, l];
    ci_high = [ci_high, h];
end


y = (ci_low + ci_high)/2;







% sort by accuracy

[x,ord] = sort(x);
y = y(ord);
ci_low = ci_low(ord);
ci_high = ci_high(ord);


% plot(x, y, ':k');
% hold on;

prop = strcat(':', plotArg('color'));
hd = errorbar(x, y, y-ci_low, ci_high-y, prop, 'MarkerSize', 0.2, 'LineWidth', 0.5);

 set(gca,'xscale','log');
 
 
 % shaded area
 % ciplot(ci_low, ci_high, x);
 
 
 
 
 
 

end