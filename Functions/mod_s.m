function [x_ts] = mod_s(s_ts, mod)
% ��������� �������� �������
x_ts = s_ts;
x_ts.Data = modulate(mod, s_ts.Data);
end

