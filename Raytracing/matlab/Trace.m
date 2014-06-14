function [result] = Trace (traceTask)

s_step1 = traceTask.sweepStep1Pass;
s_step2 = traceTask.sweepStep2Pass;

if strcmp(traceTask.traceMode1, 'single')
    s_primarySweep = s_step1;
    s_step1 = 1;
else
    s_primarySweep = 0:s_step1:360;
end
if strcmp(traceTask.traceMode2, 'single')
    s_secondarySweep = s_step2;
    s_step2 = 1;
else
    s_secondarySweep = 0:s_step2:360;
end

% Time
s_step = 0.01;
s_len = 1:s_step:15;


% Walls:				a      b    normal
s_walls = traceTask.obstacles;

s_transmitter = traceTask.transmitterPosition;
s_receiever = traceTask.receiverPosition;

s_showGraphs = traceTask.showGraphs;
s_showProgressGraphs = traceTask.showProgressGraphs;

if s_showGraphs
    figure(1);
    hold off;
    scatter(s_transmitter(1), s_transmitter(2));
    hold on;
    scatter(s_receiever(1), s_receiever(2));
    for wall = s_walls
    	line([wall.a(1), wall.b(1)], [wall.a(2), wall.b(2)]);
    end
    axis([-0.5,7.5,-0.5,7]);
end

s_points1(1, length(s_primarySweep)) = Beam();
s_points2(length(s_primarySweep), length(s_secondarySweep)) = Beam();

s_beamsR1(1, length(s_primarySweep)) = Beam();
s_beamsR2(length(s_primarySweep), length(s_secondarySweep)) = Beam();


filename = create_name([num2str(s_step1),'_', num2str(s_step2)], s_walls, s_transmitter, s_receiever);
if (s_step2 > 1) && (s_step1 > 1) && exists_data(filename)
    [beams, s_walls, s_transmitter, s_receiever] = load_data(filename);
    s_beamsR1 = beams(:, 1)';
    s_beamsR2 = beams(:, 2:end);
    
    i_a = 1;
    if s_showProgressGraphs > 0
        for beam = s_beamsR1
        	hold off;
        	scatter(s_transmitter(1), s_transmitter(2));
        	hold on;
        	scatter(s_receiever(1), s_receiever(2));
        	for wall = s_walls
        		line([wall.a(1), wall.b(1)], [wall.a(2), wall.b(2)]);
        	end
        	axis([-0.5,7.5,-0.5,7]);
            scatter(beam.start(1), beam.start(2), 100, beam.amplitude/beam.distance, 'x');

            i_b = 1;
            for b = s_secondarySweep
                pt = s_beamsR2(i_a, i_b);
                if pt.amplitude > 0
                    ampl = pt.amplitude / pt.distance;
                    x = pt.start(1);
                    y = pt.start(2);
                	scatter(x, y, 10, ampl);
                    if s_showProgressGraphs > 1
                        drawnow();
                    end
                end
                i_b = i_b + 1;
            end
            drawnow();
            i_a = i_a + 1;
        end
        % Plot result
        i_a = 1;
        for point1 = s_beamsR1
            hold off;
        	scatter(point1.start(1), point1.start(2), 100, point1.amplitude / point1.distance, 'x');
            hold on;
        	for point2 = s_beamsR2(i_a)
        		scatter(point2.start(1), point2.start(2), 10, point2.amplitude / point2.distance);
            end
            i_a = i_a + 1;
        end
        axis([-0.5,7.5,-0.5,7]);
        drawnow();
        hold off;
    end
    
else
    i_a = 1;

    for a = s_primarySweep
    	%s_points2 = Beam(s_transmitter, s_transmitter, 1, 0);
    	dir = [cos(a / 180 * pi), sin(a / 180 * pi)];
    	beam = Beam(dir, s_transmitter, 1 / length(s_primarySweep) * 2); % Disspate power over hemisphere
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

        if s_showProgressGraphs > 0
            % Plot process
        	hold off;
        	scatter(s_transmitter(1), s_transmitter(2));
        	hold on;
        	scatter(s_receiever(1), s_receiever(2));
        	for wall = s_walls
        		line([wall.a(1), wall.b(1)], [wall.a(2), wall.b(2)]);
        	end
        	axis([-0.5,7.5,-0.5,7]);
            scatter(beam.point(1), beam.point(2), 100, beam.amplitude/beam.distance, 'x');

            i_b = 1;
            for b = s_secondarySweep
                pt = s_points2(i_a, i_b);
                if pt.amplitude > 0
                    ampl = pt.amplitude / pt.distance;
                    x = pt.point(1);
                    y = pt.point(2);
                	scatter(x, y, 10, ampl);
                    if s_showProgressGraphs > 1
                        drawnow();
                    end
                end
                i_b = i_b + 1;
            end
            drawnow();
        end
            
    	s_points1(i_a) = beam;
    	i_a = 1 + i_a;
    end

    if s_showProgressGraphs
        % Plot result
        for a = 1:length(s_primarySweep)
        	scatter(s_points1(a).point(1), s_points1(a).point(2), 100, s_points1(a).amplitude/ s_points1(a).distance, 'x');
        	for b = 1:length(s_secondarySweep)
        		scatter(s_points2(a,b).point(1), s_points2(a,b).point(2), 10, s_points2(a,b).amplitude/ s_points2(a,b).distance);
        	end
        end
        axis([-0.5,7.5,-0.5,7]);
    end

    if (s_step1 > 1) && (s_step2 > 1)
        save_data(filename, [s_beamsR1', s_beamsR2], s_walls, s_transmitter, s_receiever);
    end
end

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
if s_showGraphs
    figure(2);
    scatter(graph(1, :), graph(2, :).^2, 5, 'o');
    hold on
    scatter(graph2(1, :), graph2(2, :).^2, 5, 'o');
    hold off

    set(gca, 'YScale', 'log');
    set(gca, 'YLim', [1e-14, 1e-2]);
end
% {

graph1_sorted = sortrows(graph', 1)';
graph2_sorted = sortrows(graph2', 1)';

i = 1;


graph_sum = zeros(2, numel(s_len));
graph_sum(1, :) = s_len;

for i_out = 1:length(graph_sum)
    min_ = graph_sum(1, i_out) - s_step/2;
    max_ = graph_sum(1, i_out) + s_step/2;
    
    while (graph1_sorted(1, i) > min_) && (graph1_sorted(1, i) < max_)
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
    min_ = graph_sum(1, i_out) - s_step/2;
    max_ = graph_sum(1, i_out) + s_step/2;
    
    while (graph2_sorted(1, i) < max_)
        if (graph2_sorted(1, i) < min_)
            i = 1 + i;
            if(i > size(graph2_sorted, 2))
                break;
            else
                continue;
            end
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
n_max = max(graph_sum(2, :));
graph_sum(2, :) = graph_sum(2, :) ./ n_max;
%}

if s_showGraphs
    figure(3);
    scatter(graph_sum(1, :), graph_sum(2, :).^2, 5, 'r');
    hold on
    %plot(graph2_sorted(1, :), graph2_sorted(2, :).^2);
    hold off

    set(gca, 'YScale', 'log');
    set(gca, 'YLim', [1e-6, 1]);
end
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
% {
if s_showGraphs
    figure(3);
    hold on;
    scatter(graph_sum(1, :), filtered_graph.^2, 5, 'b');
    hold off;
    figure(4);
    plot(graph_sum(1, :), filtered_graph.^2, 'b');
    set(gca, 'YLim', [1e-6, 1]);
    set(gca, 'YScale', 'log');
end
%}

result = [graph_sum(1, :); filtered_graph];
end