function [ y1_ts y2_ts ] = imitate( x1_ts, x2_ts, H, SNR, N )
%- Имитация среды распространения
% Reqires:
%	x1_ts, x2_ts, H
% Result:
%	y1_ts, y2_ts
% H11 = H(1);
% H12 = H(2);
% H21 = H(3);
% H22 = H(4);
y1_ts = propagation(H(1), x1_ts) + propagation(H(2), x2_ts);
y2_ts = propagation(H(3), x1_ts) + propagation(H(4), x2_ts);
%----------------------------
%- Добавление шума
% Reqires:
%	y1_ts, y1_ts, SNR, S
% Result:
%	y1_ts, y2_ts
y1 = y1_ts.Data;
y2 = y2_ts.Data;
%(sum(abs(y1).^2))/(numel(y1)*2)
S1 = 10*log10((sum(abs(y1).^2))/(numel(y1)*2));
S2 = 10*log10((sum(abs(y2).^2))/(numel(y2)*2));
if nargin == 5
    y1 = N*wgn(size(y1,1),size(y1,2),0,'complex') + y1;
    y2 = N*wgn(size(y1,1),size(y1,2),0,'complex') + y2;
else
    y1 = awgn(y1, SNR, S1, 'db');
    y2 = awgn(y2, SNR, S2, 'db');
end
y1_ts = timeseries(y1, y1_ts.Time);
y2_ts = timeseries(y2, y2_ts.Time);
y1_ts.Name = 'Output 1';
y2_ts.Name = 'Output 2';
end

