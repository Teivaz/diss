CCluster.StartTime = 0;     % s
CCluster.IntervalTime = 0;  % s
CCluster.StartPower = 0;    % V
CCluster.DecayPower = 0;    % 
CCluster.Number = 0;        % 

CImpulseResponse.x = [];
CImpulseResponse.y = [];

% Limits
ClusterLimits.StartTime = [6e-9, 30e-9];     % s
ClusterLimits.IntervalTime = [1e-9, 20e-9];  % s
ClusterLimits.StartPower = [0.01, 1];        % V
ClusterLimits.DecayPower = [0.9, 10];          % 
ClusterLimits.Number = [2, 8];              % 

NumberOfClusters = 3;

rnd = @(a) a(1) + (a(2)-a(1)).*rand(1,1);
rndi = @(a) a(1) + randi((a(2)-a(1)),1,1);

clusters = [];
for a = 1:NumberOfClusters
    clusters(a).StartTime    = rnd(ClusterLimits.StartTime);
    clusters(a).IntervalTime = rnd(ClusterLimits.IntervalTime);
    clusters(a).StartPower   = rnd(ClusterLimits.StartPower);
    clusters(a).DecayPower   = rnd(ClusterLimits.DecayPower);   
    clusters(a).Number       = rndi(ClusterLimits.Number);    
end

colors = hsv(NumberOfClusters);
impResp = [];
figure(2);
for a = 1:NumberOfClusters
    [x, y] = create_cluster2(clusters(a));
    impResp(a).x = x;
    impResp(a).y = y;
    h = stem(impResp(a).x, impResp(a).y);
    set(h, 'color', colors(a,:));
    set(get(h,'BaseLine'),'BaseValue',1e-6);
    set(gca, 'YScale', 'log');
    hold on;
end
%hold off;
%figure(1)

time = 1:0.1:140;
time = time.*1e-9;

two = [];
for a = 1:NumberOfClusters
    two(a).y = resample_array(impResp(a).x, impResp(a).y, time);
    Fs = 1/(time(2) - time(1));
    d = fdesign.lowpass('n,fp,fst,ast', 5, 2500e6, 2800e6, 30, Fs);
    hd = design(d);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);

    %h = semilogy(time, abs(two(a).y));
    %set(h, 'color', colors(a,:));
    hold on;
end
hold off;

Y = two(1).y;
for a = 2:NumberOfClusters
    Y = two(a).y + Y;
end
semilogy(time, Y);
ylim([1e-6, 1]);

%%
clear plt;
for a = 1:NumberOfClusters    
    if exist('plt', 'var')
        plt = [plt,[impResp(a).x;impResp(a).y]];
    else
        plt = [impResp(a).x;impResp(a).y];
    end
end
figure(3);

plt = sortrows(plt', 1)';

stem(plt(1,:), plt(2,:));


