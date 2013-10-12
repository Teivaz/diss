function [Y] = resample_array(x_old, y_old, x_new)
%RESAMPLE_ARRAY Summary of this function goes here
%   Detailed explanation goes here
Y = zeros(1, numel(x_new));
for a = 1:numel(x_old)
    deltas = abs(x_old(a) - x_new);
    idx = find(deltas == min(deltas));
    Y(idx) = y_old(a);
end

end

