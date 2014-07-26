function handle = custom_plot( x, y, y2, y3, y4, y5, y6, y7, y8 )
%custom_plot plots in gray color with different lines. Last argument should
%be array of legend for plot

if(nargin < 2)
    print('Error custom_plot takes at least 2 arguments');
    handle;
    return
elseif(nargin == 2)
    narg = 1;
    data = [y];
elseif(nargin == 3)
    legend = y2;
    narg = nargin -2;
    data = [y];
elseif(nargin == 4)
    legend = y3;
    narg = nargin - 2;
    data = [y; y2];
elseif(nargin == 5)
    legend = y4;
    narg = nargin - 2;
    data = [y; y2; y3];
elseif(nargin == 6)
    legend = y5;
    narg = nargin - 2;
    data = [y, y2, y3, y4, y5];
elseif(nargin == 7)
    legend = y6;
    narg = nargin - 2;
    data = [y, y2, y3, y4, y5, y6];
elseif(nargin == 8)
    legend = y7;
    narg = nargin - 2;
    data = [y, y2, y3, y4, y5, y6, y7];
elseif(nargin == 9)
    legend = y8;
    narg = nargin - 2;
    data = [y, y2, y3, y4, y5, y6, y7, y8];
end

if nargin > 2 && numel(legend) ~= narg
    print('Error, description size does not match number of arguments');
end

styles = ['- '; '-.'; ': '; '--'];
colors = [[.0, .0, .0];...
          [.5, .5, .5];...
          [.7, .7, .7]];

if(narg == 1)
    h = plot(x, data(1,:), styles(1,:));
elseif(narg == 2)
    h = plot(x, data(1,:), styles(1,:),...
             x, data(2,:), styles(2,:));
elseif(narg == 3)
    h = plot(x, data(1,:), styles(1,:),...
             x, data(2,:), styles(2,:),...
             x, data(3,:), styles(3,:));
end
    set(h, 'linewidth', 2)
    
    handle = h;
end

