function PlotProps( xtick, ytick )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h = gcf;
set(h, 'color', [1, 1, 1]);

a = get(h, 'CurrentAxes');
xlabel(xtick, 'fontsize', 18);
ylabel(ytick, 'fontsize', 18);

set(a, 'FontName', 'arial');
set(a, 'FontSize', 18);
set(a, 'XGrid', 'on');
set(a, 'GridLineStyle', '-');
set(a, 'XColor', [.8, .8, .8]);
set(a, 'XMinorGrid', 'on');
set(a, 'YGrid', 'on');
set(a, 'YColor', [.8, .8, .8]);
set(a, 'YMinorGrid', 'on');

ca = copyobj(a, h);
set(ca, 'color', 'none');
set(ca, 'xcolor', 'k');
set(ca, 'xgrid', 'off');
set(ca, 'xminorgrid', 'off');
set(ca, 'ycolor', 'k');
set(ca, 'yminorgrid', 'off');
set(ca, 'ygrid', 'off');

end

