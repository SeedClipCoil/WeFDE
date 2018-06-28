function draw(individual, category)
% draw error bar
% result format: direct, low, high

[X,Y,L,U] = XYLU(individual);
axes('Position',[0.1,0.1,0.7,0.7]);
errorbar(X,Y,L,U, 'k.', 'LineWidth', 1, 'MarkerEdgeColor', 'r', 'MarkerSize', 8);
grid;
axis([0, 44, 0, 0.25]);
xlabel('Feature Index', 'FontSize', 12);
ylabel('Leaked Information I(F;C)', 'FontSize', 12);

axes('Position',[0.5,0.5,0.3,0.3]);
X = 1:size(category,1);
Y = category;
plot(X,Y, '*', 'MarkerEdgeColor', 'r', 'MarkerSize', 6);
%grid;
axis([1 4 0 0.5]);
ax = gca;
set(ax,'XTickLabel','');
set(ax,'XTickLabel',{'Ptk_Num','Ord.','Bur.','1-20 Ptk'});
set(ax, 'FontSize', 12);
end



function [x,y,l,u] = XYLU(result)

feature_num = size(result,1);
x = 1:feature_num;
y = result(:,1);
l = result(:,1) - result(:,2);
u = result(:,3) - result(:,1);


end