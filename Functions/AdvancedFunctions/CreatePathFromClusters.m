function [Y, impResp, two, clstrs] = CreatePathFromClusters(clusters, time)
%CREATEPATHFROMCLUSTERS Summary of this function goes here
%   Detailed explanation goes here

NumberOfClusters = numel(clusters);

impResp = [];
for a = 1:NumberOfClusters
    [x, y] = create_cluster2(clusters(a));
    impResp(a).x = x;
    impResp(a).y = y;
end

two = [];
for a = 1:NumberOfClusters
    two(a).x = time;
    clstrs(a).x = impResp(a).x;
    clstrs(a).y = impResp(a).y;
    two(a).y = resample_array(impResp(a).x, impResp(a).y, time);
    Fs = 1/(time(2) - time(1));
    d = fdesign.lowpass('n,fp,fst,ast', 17, 2400e6, 2480e6, 100, Fs);
    hd = design(d);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);
    two(a).y = filter(hd, two(a).y);
    %two(a).y = filter(hd, two(a).y);
end
Y = two(1).y;
for a = 2:NumberOfClusters
    Y = two(a).y + Y;
end

end

