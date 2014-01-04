function [fit, y1, y2, time, fit_y , clstrs] = CostStraigntCompare( position, args )
%COSTSTRAIGNTCOMPARE Summary of this function goes here
%   Detailed explanation goes here
threshold = 1e-3;

i = 1;
clear clusters;
for a = 1:5
    cluster.StartTime = args(i)*1e-9; i=i+1;
    cluster.IntervalTime = args(i)*1e-9; i=i+1;
    cluster.StartPower = args(i); i=i+1;
    cluster.DecayPower = args(i); i=i+1;
    cluster.Number = args(i); i=i+1;  
    clusters(a) = cluster;
end

if position == 1
    load('find clusters/pos1 filtered extrems.mat');
    time = T_imp_resp_1';
    y1 = A_imp_resp_1';
elseif position == 2
    load('find clusters/pos2 filtered extrems.mat');
    time = T_imp_resp_2';
    y1 = A_imp_resp_2';
elseif position == 3
    load('find clusters/pos3 filtered extrems.mat');
    time = T_imp_resp_3';
    y1 = A_imp_resp_3';
elseif position == 4
    load('find clusters/pos4 filtered extrems.mat');
    time = T_imp_resp_4';
    y1 = A_imp_resp_4';
elseif position == 5
    load('find clusters/pos5 filtered extrems.mat');
    time = T_imp_resp_5';
    y1 = A_imp_resp_5';
elseif position == 6
    load('find clusters/pos6 filtered extrems.mat');
    time = T_imp_resp_6';
    y1 = A_imp_resp_6';
elseif position == 7
    load('find clusters/pos7 filtered extrems.mat');
    time = T_imp_resp_7';
    y1 = A_imp_resp_7';
elseif position == 8
    load('find clusters/pos8 filtered extrems.mat');
    time = T_imp_resp_8';
    y1 = A_imp_resp_8';
elseif position == 9
    load('find clusters/pos9 filtered extrems.mat');
    time = T_imp_resp_9';
    y1 = A_imp_resp_9';
else
    return;
end
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

