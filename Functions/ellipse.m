% function [ XY ] = ellipse( A, B, t0, t1 )
% %UNTITLED2 Summary of this function goes here
% %   Detailed explanation goes here
% 
% D = norm(A-B);
% angle = (A-B)/D;
% rot = [angle(1),-angle(2);angle(2),angle(1)];
% cent = (A+B)/2;
% p = [(0:0.1:2*pi),2*pi,pi];
% c = D/2;
% e = t0/t1;
% a = c/e;
% b = a*sqrt(1-e^2);
% XY = rot*[a*cos(p); b*sin(p)];
% XY(1,:) = XY(1,:)+cent(1);
% XY(2,:) = XY(2,:)+cent(2);
% 
% end

function [ XY ] = ellipse( A, B, t1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

D = norm(A-B);
angle = (A-B)/D;
rot = [angle(1),-angle(2);angle(2),angle(1)];
cent = (A+B)/2;
p = [(0:0.1:2*pi),2*pi,pi];
c = D/2;
Dx = t1*0.3;
e = D/Dx;
a = c/e;
b = a*sqrt(1-e^2);
XY = rot*[a*cos(p); b*sin(p)];
XY(1,:) = XY(1,:)+cent(1);
XY(2,:) = XY(2,:)+cent(2);

end