function [ ber err1 err2 ] = mimo_5(M, phi, H, kb, SNR, impulse_length, times_step)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
warning('off', 'interpolation:interpolation:noextrap');
bytes = 1000;
    err1 = 0;
    err2 = 0;
    for i = 1:kb
        %----------------------------
        %- Задание параметров среды
        %----------------------------
        %- Инициализация вспомогательных функций
        % Interpolation methods
        interp_hold = @(new_Time, Time, Data)interp1(Time, Data, new_Time, 'nearest');
        interp_cube = @(new_Time, Time, Data)interp1(Time, Data, new_Time, 'cubic');
        % Modulation
        mod = modem.pskmod(M, phi);
        demod = modem.pskdemod(M, phi); 
        [F S] = invert_h(16.5, times_step, H);
        %----------------------------
        %- Вычисление параметров фильтров
        delay = get_delay(impulse_length, times_step, H);
        %----------------------------
        %- Формирование последовательности
        [s1_ts s1] = rand_s(bytes, M, impulse_length, times_step);
        [s2_ts s2] = rand_s(bytes, M, impulse_length, times_step);
        max_time = impulse_length*(numel(s1)-1);
        impulse_times = 0:impulse_length:max_time;
        %----------------------------
        %- Модуляция
        [x1_ts] = mod_s(s1_ts, mod);
        [x2_ts] = mod_s(s2_ts, mod);
        %----------------------------
        %- Имитация среды распространения
        [y1_ts y2_ts] = imitate(x1_ts, x2_ts, H, SNR);
        %----------------------------
        %- Разделение пространственных каналов
        [x1__ts x2__ts] = split(y1_ts, y2_ts, F);
        %----------------------------
        %- Демодуляция и Детектирование
        [s1__ts s2__ts] = detect_s(x1__ts, x2__ts, demod);
        %----------------------------
        %- Усреднеие и пересемплирование
        % Requires:
        %	
        % Result:
        %	
        %----------------------------
        s1__ts.Time = s1_ts.Time - (2*delay(1)+impulse_length/2);
        s2__ts.Time = s2_ts.Time - (2*delay(4)+impulse_length/2);
        s1__ts = resample(s1__ts,impulse_times); 
        s1__ts.Data = round(s1__ts.Data);
        s1_ts = resample(s1_ts,impulse_times); 
        s2__ts = resample(s2__ts,impulse_times); 
        s2__ts.Data = round(s2__ts.Data);
        s2_ts = resample(s2_ts,impulse_times); 
        s1_ts = delsample(s1_ts, 'Index', [1 s1_ts.Length]);
        s2_ts = delsample(s2_ts, 'Index', [1 s2_ts.Length]);
        s1__ts = delsample(s1__ts, 'Index', [1 s1__ts.Length]);
        s2__ts = delsample(s2__ts, 'Index', [1 s2__ts.Length]);
        %----------------------------
        %- Вычисление ошибок
        % Requires:
        %	
        % Result:
        %	
        %----------------------------
        err1 = err1 + sum(s1_ts.Data ~= s1__ts.Data);
        err2 = err2 + sum(s2_ts.Data ~= s2__ts.Data);
    end
    
    ber = (err1 + err2)/(2*kb*bytes);
    warning('on', 'interpolation:interpolation:noextrap');
end

