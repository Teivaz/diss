clear all

s_step1 = 2;
s_step2 = 2;

s_primarySweep = 0:s_step1:360;
s_secondarySweep = 0:s_step2:360;

% Time
s_step = 0.01;
s_len = 1:s_step:14;


% Walls:				a      b    normal
s_walls(1) = Segment( [0,0], [7,0], [0,1] );	% Bottom
s_walls(2) = Segment( [7,0], [7,6], [-1,0] ); % Right
s_walls(3) = Segment( [7,6], [0,6], [0,-1] );	% Top
s_walls(4) = Segment( [0,6], [0,0], [1,0] );	% Left
    
    s_walls(5) = Segment( [1,5], [6,5], [0,-1] );	% top obstacles

%s_transmitter = [4.1, 3.5];
s_transmitter = [4.1, 3.57];
s_receiever = [6.3, 3.4];

figure(1);
hold off;
scatter(s_transmitter(1), s_transmitter(2));
hold on;
scatter(s_receiever(1), s_receiever(2));
for wall = s_walls
	line([wall.a(1), wall.b(1)], [wall.a(2), wall.b(2)]);
end
axis([-0.5,7.5,-0.5,6.5]);

s_points1(1, length(s_primarySweep)) = Beam();
s_points2(length(s_primarySweep), length(s_secondarySweep)) = Beam();

s_beamsR1(1, length(s_primarySweep)) = Beam();
s_beamsR2(length(s_primarySweep), length(s_secondarySweep)) = Beam();

i_a = 1;

for a = s_primarySweep
	%s_points2 = Beam(s_transmitter, s_transmitter, 1, 0);
	dir = [cos(a / 180 * pi), sin(a / 180 * pi)];
	beam = Beam(dir, s_transmitter, 1 / length(s_primarySweep)); % Disspate power
	[beam, wallNum] = Reflect(s_walls, 0, beam);
    beam = beam.SumUpDistance();

    % Trace to receiever
    dirRecieverN = norm(s_receiever - beam.point);
    dirReciever = (s_receiever - beam.point)./dirRecieverN;
    if(wallNum == 0)
    	continue;
    end
    beamReceiver = ScatterWall(beam, s_walls(wallNum), dirReciever);
    beamReceiver = beamReceiver.AddIntersectionPoint(s_receiever, 0);
    beamReceiver = beamReceiver.SumUpDistance();
    s_beamsR1(i_a) = beamReceiver;
    
    i_b = 1;
    for b = s_secondarySweep
        dir2 = [cos(b / 180 * pi), sin(b / 180 * pi)];
        beam2 = ScatterWall(beam, s_walls(wallNum), dir2);
        beam2.amplitude = beam2.amplitude ./ length(s_secondarySweep); % Disspate power
        [beam2, wallNum2] = Reflect(s_walls, wallNum, beam2);
        beam2 = beam2.SumUpDistance();
        s_points2(i_a, i_b) = beam2;
        i_b = i_b + 1;
        
        % Trace to receiver
        dirRecieverN = norm(s_receiever - beam2.point);
        dirReciever = (s_receiever - beam2.point)./dirRecieverN;

        if(wallNum2 == 0)
            continue;
        end

        beamReceiver = ScatterWall(beam2, s_walls(wallNum2), dirReciever);
        beamReceiver = beamReceiver.AddIntersectionPoint(s_receiever, 0);
        beamReceiver = beamReceiver.SumUpDistance();
        s_beamsR2(i_a, i_b) = beamReceiver;
    end

    %{
    % Plot process
	hold off;
	scatter(s_transmitter(1), s_transmitter(2));
	hold on;
	scatter(s_receiever(1), s_receiever(2));
	for wall = s_walls
		h = line([wall.a(1), wall.b(1)], [wall.a(2), wall.b(2)]);
		plot(h);
	end
	axis([-0.5,7.5,-0.5,6.5]);

    i_b = 1;
    for b = s_secondarySweep
        if s_points2(i_b).amplitude > 0
            ampl = s_points2(i_b).amplitude / s_points2(i_b).distance;
            x = s_points2(i_b).point(1);
            y = s_points2(i_b).point(2);
        	scatter(x, y, 10, ampl);
        end
        i_b = i_b + 1;
    end
    scatter(beam.point(1), beam.point(2), 100, beam.amplitude/beam.distance, 'x');
    drawnow();
    %}
        
	s_points1(i_a) = beam;
	i_a = 1 + i_a;
end

%{
% Plot result
for a = 1:length(s_primarySweep)
	scatter(s_points1(a).point(1), s_points1(a).point(2), 100, s_points1(a).amplitude/ s_points1(a).distance, 'x');
	for b = 1:length(s_secondarySweep)
		scatter(s_points2(a,b).point(1), s_points2(a,b).point(2), 10, s_points2(a,b).amplitude/ s_points2(a,b).distance);
	end
end
axis([-0.5,7.5,-0.5,6.5]);
%}

save_data(['steps_', num2str(s_step1),'_', num2str(s_step2)], [s_points1; s_points2], s_walls, s_transmitter, s_receiever);

graph = zeros(2, numel(s_beamsR1));
graph2 = zeros(2, numel(s_beamsR2));
i_a = 1;
i2 = 1;
for beam = s_beamsR1
	graph(:, i_a) = [beam.distance; beam.amplitude/beam.distance];
    i_b = 1;
    for b = s_secondarySweep
        beam2 = s_beamsR2(i_a, i_b);
        graph2(:, i2) = [beam2.distance; beam2.amplitude/beam2.distance];
        i2 = i2 + 1;
        i_b = i_b + 1;
    end
	i_a = 1 + i_a;
end

%%

figure(2);
scatter(graph(1, :), graph(2, :).^2, 5, 'o');
hold on
scatter(graph2(1, :), graph2(2, :).^2, 5, 'o');
hold off

set(gca, 'YScale', 'log');
set(gca, 'YLim', [1e-14, 1e-2]);

% {

graph1_sorted = sortrows(graph', 1)';
graph2_sorted = sortrows(graph2', 1)';

i = 1;


graph_sum = zeros(2, numel(s_len));
graph_sum(1, :) = s_len;

for i_out = 1:length(graph_sum)
    min = graph_sum(1, i_out) - s_step/2;
    max = graph_sum(1, i_out) + s_step/2;
    
    while (graph1_sorted(1, i) > min) && (graph1_sorted(1, i) < max)
        graph_sum(2, i_out) = graph1_sorted(2, i) + graph_sum(2, i_out);
        i = 1 + i;
        if i > length(graph1_sorted)
            break;
        end
    end
    if i > length(graph1_sorted)
        break;
    end
end

i = 1;

for i_out = 1:length(graph_sum)
    min = graph_sum(1, i_out) - s_step/2;
    max = graph_sum(1, i_out) + s_step/2;
    
    while (graph2_sorted(1, i) < max)
        if (graph2_sorted(1, i) < min)
            i = 1 + i;
            continue;
        end
        graph_sum(2, i_out) = graph2_sorted(2, i) + graph_sum(2, i_out);
        i = 1 + i;
        if i > length(graph2_sorted)
            break;
        end
    end
    if i > length(graph2_sorted)
        break;
    end
end

% { Normalize
clear max;
n_max = max(graph_sum(2, :));
graph_sum(2, :) = graph_sum(2, :) ./ n_max;
%}

figure(3);
scatter(graph_sum(1, :), graph_sum(2, :).^2, 5, 'r');
hold on
%plot(graph2_sorted(1, :), graph2_sorted(2, :).^2);
hold off

set(gca, 'YScale', 'log');
set(gca, 'YLim', [1e-6, 1]);

%}

%%

fp = 3;
fst = 5;
ap = 3;
ast = 100;
n = 17;
Fs = 1/(graph_sum(1,2)-(graph_sum(1,1)));
ftr = fdesign.lowpass('n,fp,ap', n, fp, ap, Fs);
hftr = design(ftr);


filtered_graph = filter(hftr, graph_sum(2,:));
filtered_graph = filtered_graph ./ max(filtered_graph);
figure(3);
hold on;
scatter(graph_sum(1, :), filtered_graph.^2, 5, 'b');
hold off;
figure(4);
plot(graph_sum(1, :), filtered_graph.^2, 'b');
set(gca, 'YLim', [1e-6, 1]);
set(gca, 'YScale', 'log');
