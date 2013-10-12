function [X, Y] = create_cluster2(clusterStruct)
%create_cluster2 Creates series of amplitude-time point basing on cluster
%parmetersx
%   Detailed explanation goes here
X = zeros(1, clusterStruct.Number);
Y = zeros(1, clusterStruct.Number);

X(1) = clusterStruct.StartTime;
Y(1) = clusterStruct.StartPower;
for a = 2:clusterStruct.Number
   X(a) = clusterStruct.IntervalTime + X(a-1);
   Y(a) = Y(a-1)/clusterStruct.DecayPower;
end
end