function [X, Y] = create_cluster(t0, a0, decay, number, deltaTime, mode)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
X = zeros(1, number);
Y = zeros(1, number);

dt = deltaTime;
if(strcmp(mode, 'length'))
    dt = (deltaTime - t0)/(number - 1);
elseif(strcmp(mode, 'delta'))
    dt = deltaTime;
end

X(1) = t0;
Y(1) = a0;
for a = 2:number
   X(a) = dt + X(a-1);
   Y(a) = Y(a-1)/decay;
end
end