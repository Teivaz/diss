function [ X, Y ] = ToParamteric( Line, p )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
A = Line(1); B = Line(2); C = Line(3);

if(A == 0)
    x0 = 0;
    y0 = -C/B;
else
    x0 = -C/A;
    y0 = 0;
end
X = B*p - x0;
Y = A*p - y0;

end

