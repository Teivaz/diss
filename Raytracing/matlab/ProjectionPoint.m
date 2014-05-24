function [ Projection ] = ProjectionPoint( Point, Line )
%ProjectionPoint Summary of this function goes here
%   Detailed explanation goes here
ax = Point(1); ay = Point(2);
A = Line(1); B = Line(2); C = -Line(3);

% Calculate normals
n = sqrt(A*A + B*B);
nx = A/n;
ny = B/n;

syms h;
h1 = solve((ax-nx*h)*A + (ay-ny*h)*B + C, h);
h1 = double(h1);

Projection = [(ax-nx*h1), (ay-ny*h1)];

end

