function [ ber err1 err2 ] = mimo_6(M, phi, H, kb, SNR, impulse_length, times_step, N)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
warning('off', 'interpolation:interpolation:noextrap');

bytes = 1000;
show_plot = 0;

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
        %[F S] = invert_h(impulse_length, times_step, H);
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
        x1_ts = setinterpmethod(x1_ts, interp_cube);
        x2_ts = setinterpmethod(x2_ts, interp_cube);
        %----------------------------
        %- Имитация среды распространения
        [y1_ts y2_ts] = imitate(x1_ts, x2_ts, H, SNR, N);
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

    if show_plot == 1
        figure(1)
        subplot(2,1,1)
        plot(...
            (x1_ts)...
            ,'b')
        hold on
        plot(...
            (s1_ts)...
            ,'g')
        plot(...
            (s1__ts)-1.1...
            ,'r')
        plot(...
            (x1__ts)...
            ,'k')
        hold off
        legend(x1_ts.Name ,s1_ts.Name ,y1_ts.Name ,x1__ts.Name )
        %ylim([-2 2]);
        xlim([100 max_time])

        subplot(2,1,2)
        plot(...
            (x2_ts)...
            ,'b')
        hold on
        plot(...
            (s2_ts)...
            ,'g')
        plot(...
            (s2__ts)-1.1...
            ,'r')
        plot(...
            (x2__ts)...
            ,'k')
        hold off
        %ylim([-2 2]);
        xlim([100 max_time])
    end

    ber = (err1 + err2)/(2*kb*bytes);
    warning('on', 'interpolation:interpolation:noextrap');
end

