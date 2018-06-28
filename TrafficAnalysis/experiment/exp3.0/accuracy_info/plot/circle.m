function h = circle(xCenter,yCenter,xRadius, yRadius)
theta = 0 : 0.01 : 2*pi;
x = xRadius * cos(theta) + xCenter;
y = yRadius * sin(theta) + yCenter;
plot(x, y, 'LineWidth', 1);
axis square;
xlim([0 20]);
ylim([0 20]);
grid on;

end