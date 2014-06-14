task = TraceTask();

task.sweepStep1Pass = 2;
task.sweepStep2Pass = 2;
task.obstacles(1) = Segment( [0,0], [7,0], [0,1] );	% Bottom
task.obstacles(2) = Segment( [7,0], [7,6], [-1,0] );   % Right
task.obstacles(3) = Segment( [7,6], [0,6], [0,-1] );	% Top
task.obstacles(4) = Segment( [0,6], [0,0], [1,0] );	% Left    
task.obstacles(5) = Segment( [1,5], [6,5], [0,-1] );	% top obstacles

task.transmitterPosition = [4.1, 3.57];
task.receiverPosition = [6.3, 3.4];

task.showGraphs = 0;


i = 1;
delta = 0.1;
clear result;

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


