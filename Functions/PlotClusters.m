function state = PlotClusters(impulseResponse, options, state, flag)
%PLOTCLUSTERS Summary of this function goes here
%   Detailed explanation goes here

if(strcmp(flag,'init'))

end
args = state.Population(min(state.Score)==state.Score, :);

[fit, y1, y2, x, y3] = CostStraightCompare(impulseResponse, args);
    
a = area( x, y3, 1e-5);
set(a, 'FaceColor', [166, 198, 198]./255, 'LineStyle', 'none');
hold on;
plot(x, y1, '-r', x, y2, '-b');
hold off;
set(gca, 'YScale', 'log', 'YLim', [1e-3, 1]);

title(['Generation: ', num2str(state.Generation), ' Fitness: ' num2str(min(state.Score))]);

end

