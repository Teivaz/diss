function [ H ] = load_channel(  )
%load_channel Load measured data
Cluster = struct('Start',0, 'Step',0, 'Time', 0, 'Data', 0, 'Size',0, 'MaxTime', 0);
ImpulseResponse = struct('Cluster', Cluster, 'Size',0, 'MaxTime', 0);

% H11
h11_c1 = [1374	0];
bgn11_c1 = 7.38;
stp11_c1 = 1.2;
h11_c2 = [0 0];
bgn11_c2 = 17.4;
stp11_c2 = 1.2;
h11_c3 = [0 0];
bgn11_c3 = 25.03;
stp11_c3 = 1.9;

% H12
h12_c1 = [0	1276	0];
bgn12_c1 = 7.28;
stp12_c1 = 1.25;
h12_c2 = [0 0];
bgn12_c2 = 15.25;
stp12_c2 = 1.6;
h12_c3 = [0 0];
bgn12_c3 = 22.36;
stp12_c3 = 1.79;

% H21
h21_c1 = [814	321.8	437.7];
bgn21_c1 = 7.28;
stp21_c1 = 1.14;
h21_c2 = [0 0];
bgn21_c2 = 14.88;
stp21_c2 = 1.4;
h21_c3 = [0 0];
bgn21_c3 = 23.66;
stp21_c3 = 1;

% H22
h22_c1 = [687	617.4];
bgn22_c1 = 7.22;
stp22_c1 = 2;
h22_c2 = [0 0];
bgn22_c2 = 17.99;
stp22_c2 = 0.7;
h22_c3 = [0 0];
bgn22_c3 = 24.75;
stp22_c3 = 2.25;

H = ImpulseResponse;
time = @(step, data)(0:step:(step*numel(data)-1));
i = 1;
    H(i).Size = 3;
    l = 1;
        H(i).Cluster(l).Data = h11_c1;
        H(i).Cluster(l).Start = bgn11_c1;
        H(i).Cluster(l).Step = stp11_c1;
        H(i).Cluster(l).Time = time(stp11_c1, h11_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2;
        H(i).Cluster(l).Data = h11_c2;
        H(i).Cluster(l).Start = bgn11_c2;
        H(i).Cluster(l).Step = stp11_c2;
        H(i).Cluster(l).Time = time(stp11_c2, h11_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3;
        H(i).Cluster(l).Data = h11_c3;
        H(i).Cluster(l).Start = bgn11_c3;
        H(i).Cluster(l).Step = stp11_c3;
        H(i).Cluster(l).Time = time(stp11_c3, h11_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
i = 2;
    H(i).Size = 3;
    l = 1;
        H(i).Cluster(l).Data = h12_c1;
        H(i).Cluster(l).Start = bgn12_c1;
        H(i).Cluster(l).Step = stp12_c1;
        H(i).Cluster(l).Time = time(stp12_c1, h12_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2;
        H(i).Cluster(l).Data = h12_c2;
        H(i).Cluster(l).Start = bgn12_c2;
        H(i).Cluster(l).Step = stp12_c2;
        H(i).Cluster(l).Time = time(stp12_c2, h12_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3;
        H(i).Cluster(l).Data = h12_c3;
        H(i).Cluster(l).Start = bgn12_c3;
        H(i).Cluster(l).Step = stp12_c3;
        H(i).Cluster(l).Time = time(stp12_c3, h12_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
i = 3;
    H(i).Size = 3;
    l = 1;
        H(i).Cluster(l).Data = h21_c1;
        H(i).Cluster(l).Start = bgn21_c1;
        H(i).Cluster(l).Step = stp21_c1;
        H(i).Cluster(l).Time = time(stp21_c1, h21_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2;
        H(i).Cluster(l).Data = h21_c2;
        H(i).Cluster(l).Start = bgn21_c2;
        H(i).Cluster(l).Step = stp21_c2;
        H(i).Cluster(l).Time = time(stp21_c2, h21_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3;
        H(i).Cluster(l).Data = h21_c3;
        H(i).Cluster(l).Start = bgn21_c3;
        H(i).Cluster(l).Step = stp21_c3;
        H(i).Cluster(l).Time = time(stp21_c3, h21_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
i = 4;
    H(i).Size = 3;
    l = 1;
        H(i).Cluster(l).Data = h22_c1;
        H(i).Cluster(l).Start = bgn22_c1;
        H(i).Cluster(l).Step = stp22_c1;
        H(i).Cluster(l).Time = time(stp22_c1, h22_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2;
        H(i).Cluster(l).Data = h22_c2;
        H(i).Cluster(l).Start = bgn22_c2;
        H(i).Cluster(l).Step = stp22_c2;
        H(i).Cluster(l).Time = time(stp22_c2, h22_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3;
        H(i).Cluster(l).Data = h22_c3;
        H(i).Cluster(l).Start = bgn22_c3;
        H(i).Cluster(l).Step = stp22_c3;
        H(i).Cluster(l).Time = time(stp22_c3, h22_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);

        for i = 1:numel(H)
            for l = 1:H(i).Size
                H(i).Cluster(l).MaxTime = max(H(i).Cluster(l).Time(end)+H(i).Cluster(l).Start);
            end
            H(i).MaxTime = max([H(i).Cluster(:).MaxTime]);
        end
end

