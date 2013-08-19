function [ s1__ts s2__ts ] = detect_s( x1__ts, x2__ts, demod )
%- Демодуляция и Детектирование
%	x1_ts, x2_ts, demod
% Result: 
%	s1__ts, s2__ts
x1_ = x1__ts.Data;
x2_ = x2__ts.Data;
s1_ = demodulate(demod, x1_);
s2_ = demodulate(demod, x2_);
s1__ts = timeseries(s1_, x1__ts.Time);
s2__ts = timeseries(s2_, x2__ts.Time);
s1__ts.Name = 'Demodulated output 1';
s2__ts.Name = 'Demodulated output 2';
end

