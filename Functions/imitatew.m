function [y1_ts y2_ts w_ts] = imitatew(x1_ts, x2_ts, H, SNR, Hw)
% »митаци€ канала распространени€, характеристики которого описаны 
% матрицами H и Hw. 

y1_ts = propagation(H(1), x1_ts) + propagation(H(2), x2_ts);
y2_ts = propagation(H(3), x1_ts) + propagation(H(4), x2_ts);
w_ts = propagation(Hw(1), x1_ts) + propogation(Hw(2), x2_ts);
%----------------------------
%- ƒобавление шума
% Reqires:
%	y1_ts, y1_ts, SNR, S
% Result:
%	y1_ts, y2_ts
y1 = y1_ts.Data;
y2 = y2_ts.Data;
w = w2_ts.Data;
%(sum(abs(y1).^2))/(numel(y1)*2)
S1 = 10*log10((sum(abs(y1).^2))/(numel(y1)*2));
S2 = 10*log10((sum(abs(y2).^2))/(numel(y2)*2));
Sw = 10*log10((sum(abs(w).^2))/(numel(w)*2));
y1 = awgn(y1, SNR, S1, 'db');
y2 = awgn(y2, SNR, S2, 'db');
w = awgn(w, SNR, Sw, 'db');
y1_ts = timeseries(y1, y1_ts.Time);
y2_ts = timeseries(y2, y2_ts.Time);
w_ts = timeseries(w, w_ts.Time);
end
