%paths_x = zeros(9,5);
%paths_y = zeros(9,5);
X_ = 1:5;
Y_ = [6, 7, 3, 8, 9];
for i = X_
    load(['find clusters/mat/opt_' num2str(i) '.mat']);
    
    figure(3);
    [fit, y1, y2, x, fity, clstrs] = CostStraigntCompare(i, X);
    %areaHandle = area(x, y1);
    hold on;
    set(gca, 'YScale', 'log'); 
    %set(areaHandle, 'BaseValue', 1e-3);
    %set(areaHandle, 'FaceColor', [166, 198, 198]./255, 'LineStyle', 'none');

    %h = semilogy(x, y1, 'k', x, y2, '--k');
    %h = semilogy(x, y2, '--k');
    %set(h, 'linewidth', 2);

    %semilogy(x, y2);

    colors = hsv(5);
    for a = 1:numel(clstrs)
        paths_x(i, a) = clstrs(a).x(1)+ 2.2e-9;
        paths_y(i, a) = clstrs(a).y(1);
        if(mod(i,2))
            h = stem(clstrs(a).x+ 2.2e-9, clstrs(a).y, 'o');%
        else
            h = stem(clstrs(a).x+ 2.2e-9, clstrs(a).y, ':o');%
        end
            
        set(h, 'color', colors(a,:));
        set(get(h,'BaseLine'),'BaseValue',1e-3);
        %set(h, 'linewidth', 2);
    end
    hold off
    xlim([0, 5e-8])
    ylim([1e-3, 1])
    PlotProps('Время, с', '');
    drawnow;
    %pause(0.9);
end
%%
figure(1);

path = 3;
colors = hsv(5);
x = paths_x(X_,:);
y = paths_y(X_,:);
for path = 1:5
    for a = 1:numel(paths_x(:,path))
        text(paths_x(a,path), paths_y(a,path) + 0.02, num2str(a));
    end
    data = [x(:,path), y(:,path)];
    h = line(data(:,1), data(:,2));
    set(h, 'color', colors(path,:));
    %set(gca, 'YScale', 'log'); 
    %set(h, 'HeadStyle', 'plain');
end

x = paths_x(Y_,:);
y = paths_y(Y_,:);
for path = 1:5
    for a = 1:numel(paths_x(:,path))
        text(paths_x(a,path), paths_y(a,path) + 0.02, num2str(a));
    end
    data = [x(:,path), y(:,path)];
    h = line(data(:,1), data(:,2));
    set(h, 'color', colors(path,:));
    %set(gca, 'YScale', 'log'); 
    %set(h, 'HeadStyle', 'plain');
end
