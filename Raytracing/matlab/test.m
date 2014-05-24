


clear all
line = Segment([-1,1], [1,1], [0,-1]);
%beam = Beam([-1,2], [0,0])''
beam = Beam([-1,1], [0,0]);
[a,b] = line.Intersect(beam);
b
