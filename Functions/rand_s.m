function [s_ts s] = rand_s(bytes, M, impulse_length, times_step)
% ������������ ��������� ������������������ �� bytes ���, �������������
% impulse_length, 
    % ������������ ������� ������������ ��� ����������������� ���������
    % �������������������
    interp_hold = @(new_Time, Time, Data)... % ��� ������������
        interp1(Time, Data, new_Time, 'nearest', 'extrap');
    interp_cube = @(new_Time, Time, Data)... % ���������� ������������
        interp1(Time, Data, new_Time, 'cubic', 'extrap');
    % ��������� ������������������ ��������� ����� �����.
    % � ������ � ����� ������������������ ��������� �������, ����������� ���
    % ��������� ������� � �������������� �����, � ����� ��� ���������� ������
    % ��� ��������� ��������� � ����������� �������, ��������� � ���������
    % ��� ���������������.
    s = [zeros(1, 1) randi(M, 1, bytes)-1 zeros(1, 1)]';
    max_time = impulse_length*(numel(s)-1); % ����� ���������� ��������
    impulse_times = 0:impulse_length:max_time; % ������ ������ ����������.
    times = 0:times_step:max_time; % ������ ������� ������������������ ����������.
    s_ts = timeseries(s, impulse_times); % ������������ ��������� ����������.
    s_ts = setinterpmethod(s_ts, interp_hold); % ��������� ������ ������������
    s_ts = resample(s_ts, times); % ����������������� ��� ������������
    s_ts = setinterpmethod(s_ts, interp_cube); % ��������� ������ ������������
end

