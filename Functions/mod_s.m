function [x_ts] = mod_s(s_ts, mod)
% Модуляция входного сигнала
x_ts = s_ts;
x_ts.Data = modulate(mod, s_ts.Data);
end

