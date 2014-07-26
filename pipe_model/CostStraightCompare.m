function [fit, y1, y2, time, fit_y , clstrs] = CostStraightCompare( target, args )
threshold = 1e-3;

i = 1;
clear clusters;
for a = 1:5
    cluster.StartTime = args(i); i=i+1;
    cluster.IntervalTime = args(i); i=i+1;
    cluster.StartPower = args(i); i=i+1;
    cluster.DecayPower = args(i); i=i+1;
    cluster.Number = args(i); i=i+1;  
    clusters(a) = cluster;
end

time = target.time;
y1 = target.value;

[y2 impResp two clstrs] = CreatePathFromClusters(clusters, time);
y1 = y1./max(abs(y1));
y2 = y2./max(abs(y2));
y1(y1<threshold) = 0;
y2(y2<threshold) = 0;
fit_y = abs(y1 - y2);
%fit_y = abs(1 - y2./max(y1, 1e-9));
%fit_y = abs((y1.^2-y2.^2));

%fit_y = fit_y./numel(time).*100;
fit = sum(fit_y); 
end

