figure(2)

cmap = hsv(9);

x1 = 2.688;
x2 = 3.875;
dx = x2 - x1;
ex3_ampl = db2mag((POS(:,2)));
maxval = max([ex3_ampl]);%; ex2_ampl; ex3_ampl; ex4_ampl; ex5_ampl]);
ex1_time = POS(:,1)*1e9 - dx;
ex3_ampl = ex3_ampl./maxval;
plot(ex1_time, ex3_ampl, 'color', cmap(1,:));
hold on

for a = 1:size(POWER, 2)
    text(TIME(a), POWER(a)*(1.1 + 0.3*rand(1,1)), int2str(a));
    scatter(TIME(a), POWER(a), 50, cmap(a,:), 'DisplayName', 'a');
end
hold off;
xlim([0, 40]);
set(gca, 'XTick', 0:40);
set(gca, 'YScale', 'log');
grid;



%%
cmap = hsv(9);
xy1 = ellipse([x1, y1], [x2, y2], TIME(1, 1));
%xy1 = [xy1; zeros(1, size(xy1, 2)) + 0];
xy2 = ellipse([x1, y1], [x2, y2], TIME(1, 2));
%xy2 = [xy2; zeros(1, size(xy2, 2)) + 2];
xy3 = ellipse([x1, y1], [x2, y2], TIME(1, 3));
%xy3 = [xy3; zeros(1, size(xy3, 2)) + 4];
xy4 = ellipse([x1, y1], [x2, y2], TIME(1, 4));
%xy4 = [xy4; zeros(1, size(xy4, 2)) + 2];
xy5 = ellipse([x1, y1], [x2, y2], TIME(1, 5));
%xy5 = [xy5; zeros(1, size(xy5, 2)) + 1];
%xy = [xy2, xy3, xy4, xy5];

figure(1)
hold on;
for a = 1:size(TIME, 2)
    xy = ellipse([x1, y1], [x2, y2], TIME(1, a));
    text(xy(1,50), xy(2,50), int2str(a));
    plot(xy(1,:), xy(2,:), 'color', cmap(a,:));
end
hold off
xlim([-0.1, 6.0]);
ylim([-0.1, 5.5]);
set(gca, 'DataAspectRatio', [1, 1, 1]);
%%
ax = -0.1:0.1:6.0;
ay = -0.1:0.1:5.5;
[XI,YI] = meshgrid(ax,ax);
z = griddata(xy(1,:), xy(2,:), xy(3,:), XI, YI);
contour(XI, YI, z, 'LineStyle', '-');
