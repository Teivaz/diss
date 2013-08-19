function [s_ts s] = rand_s(bytes, M, impulse_length, times_step)
% Формирование случайной последовательности из bytes бит, длительностью
% impulse_length, 
    % Опеределение методов интерполяции при пересемплировании временных
    % последовательностей
    interp_hold = @(new_Time, Time, Data)... % Без интерполяции
        interp1(Time, Data, new_Time, 'nearest', 'extrap');
    interp_cube = @(new_Time, Time, Data)... % Кубическая интерполяция
        interp1(Time, Data, new_Time, 'cubic', 'extrap');
    % Генерация последовательности случайных целых чисел.
    % В начале и конце последовательности добавлены символы, необходимые для
    % выведения системы в установившийся режим, а также для устранения ошибок
    % при сравнении исходного и полученного сигнала, связанных с задержкой
    % его распространения.
    s = [zeros(1, 1) randi(M, 1, bytes)-1 zeros(1, 1)]';
    max_time = impulse_length*(numel(s)-1); % Время последнего импульса
    impulse_times = 0:impulse_length:max_time; % Вектор врмени последоват.
    times = 0:times_step:max_time; % Вектор времени пересемплированной последоват.
    s_ts = timeseries(s, impulse_times); % Формирования временной последоват.
    s_ts = setinterpmethod(s_ts, interp_hold); % Установка метода интерполяции
    s_ts = resample(s_ts, times); % Пересемплирование без интерполяции
    s_ts = setinterpmethod(s_ts, interp_cube); % Установка метода интерполяции
end

