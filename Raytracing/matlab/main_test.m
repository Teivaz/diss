task = TraceTask();

n_l = [-1, 0];
n_r = [1, 0];
n_u = [0, 1];
n_d = [0, -1];

task.showGraphs = 0;
task.showProgressGraphs = 1;

task.traceMode1 = 'single';
task.traceMode2 = 'single';

task.sweepStep1Pass = 50;
task.sweepStep2Pass = 1000;
task.obstacles(1) = Segment( [0,0], [7,0], [0,1] );	% Bottom
task.obstacles(2) = Segment( [7,0], [7,6.51], [-1,0] );   % Right
task.obstacles(3) = Segment( [7,6.51], [0,6.51], [0,-1] );	% Top
task.obstacles(4) = Segment( [0,6.51], [0,0], [1,0] );	% Left   

items = ...
[
[ [0,0], [0.0, 0.55], n_l ];...
[ [0,0.55], [0.92, 0.55], n_u ];...
[ [0.92, 0.55], [0.92, 0], n_r ];...
[ [0.95, 0.86], [2.56, 0.86], n_u ];...
%[ [2.56, 0.86], [2.56, 0.00], n_l ];...
[ [0.95, 0.00], [0.95, 0.86], n_l ];...
[ [2.56, 0.86], [4.16, 0.86], n_u ];...
[ [4.16, 0.86], [4.16, 0.00], n_r ];...
[ [4.95, 1.60], [4.95, 0.00], n_l ];...
[ [4.95, 1.60], [5.77, 1.60], n_d ];...
[ [5.77, 1.60], [5.77, 0.00], n_r ];...
[ [7.00, 1.93], [6.18, 1.93], n_d ];...
[ [6.18, 1.93], [6.18, 3.53], n_l ];...
%[ [6.18, 3.53], [7.00, 3.53], n_u ];...
[ [6.18, 3.53], [6.18, 5.14], n_l ];...
[ [6.18, 5.14], [7.00, 5.14], n_u ];...
[ [5.91, 6.51], [5.91, 5.69], n_r ];...
[ [5.91, 5.69], [4.30, 5.69], n_d ];...
%[ [4.30, 5.69], [4.30, 6.51], n_l ];...
[ [4.30, 5.69], [2.70, 5.69], n_d ];...
%[ [2.70, 5.69], [2.70, 6.51], n_l ];...
[ [2.70, 5.69], [1.09, 5.69], n_d ];...
[ [1.09, 5.69], [1.09, 6.51], n_l ];...
[ [1.92, 4.38], [3.53, 4.38], n_u ];...
%[ [3.53, 4.38], [3.53, 2.75], n_r ];...
[ [3.53, 2.75], [1.92, 2.75], n_d ];...
[ [1.92, 2.75], [1.92, 4.38], n_l ];...
%[ [1.92, 3.56], [3.53, 3.56], n_u ];...
[ [3.53, 4.38], [4.03, 4.21], [0.5369, -0.8437] ];... ([3.94, 4.41] - [3.87, 4.52]) ];...
[ [4.03, 4.21], [4.35, 3.56], [0.9439, 0.3304] ];... ([4.57, 3.93] - [4.37, 3.86]) ];...
[ [4.35, 3.56], [4.09, 2.98], [0.9191, -0.3939] ];... ([4.50, 3.34] - [4.29, 3.43]) ];...
[ [4.09, 2.98], [3.53, 2.75], [0.3511, -0.9363] ];... ([4.03, 2.76] - [3.97, 2.92]) ]...
];

for i = 1:size(items, 1)
    a = items(i, 1:2);
    b = items(i, 3:4);
    c = items(i, 5:6);
	task.obstacles(i + 4) = Segment(a, b, c);
end


task.transmitterPosition = [1.23, 3.68];
task.receiverPosition = [1.23, 2.46];


i = 1;
delta = 0.1;
clear result;

Trace(task);
%{
X = 0.5 : 0.5 : 6.5;
Y = 0.5 : 0.5 : 5.5;
SIZE = numel(X) * numel(Y);
num = 0;

for x = X
	j = 1;
	for y = Y
		task.transmitterPosition = [x - delta, y - delta];
		a = Trace(task);
		task.transmitterPosition = [delta + x, delta + y];
		b = Trace(task);
		result(i, j) = sum(conv(a(2, :), b(2, :)));
		j = j + 1;
        num = num + 1;
        msg = ['Progress: ' num2str(num / SIZE * 100), '%'];
        display(msg);
	end
	i = i + 1;
end

contour(result,'DisplayName','result');figure(gcf)

%%
hold off

mi = min(min(result));
ma = max(max(result));

for x = 1:size(result, 1)
for y = 1:size(result, 2)
    value = 1 - (result(x, y) - mi) / (ma - mi);
plot(x, y, 's', 'MarkerSize', 27, 'Color', [1, 1, 1] * value, 'MarkerFaceColor', [1, 1, 1] * value);
hold on;
end
end
hold off

%}

