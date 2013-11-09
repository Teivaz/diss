function [X, Y] = create_cluster2(clusterStruct)
%create_cluster2 Creates series of amplitude-time point basing on cluster
%parmetersx
%   Detailed explanation goes here
number = ceil(clusterStruct.Number);
X = zeros(1, number);
Y = zeros(1, number);

X(1) = clusterStruct.StartTime;
Y(1) = clusterStruct.StartPower;
for a = 2:number
   X(a) = clusterStruct.IntervalTime + X(a-1);
   Y(a) = Y(a-1)/clusterStruct.DecayPower;
end
end