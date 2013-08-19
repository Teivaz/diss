function [H] = create_channel(...
            H_decay,...     % Коэффициент затухания амплитуд кластеров
            Cl_decay,...    % Коэффициенты затухания амплитуд в кластерах
            Cl_time,...     % Интервалы прихода импульсов в кластерах [нс]
            Cl_size,...     % Количество импульсов в кластерах
            Cl_pos,...      % Координаты кластеров
            Tx_pos,...      % Координаты передатчика
            Rx_pos,...      % Координаты приёмника
            units,...       % Размерность расстояния 'm', 'cm', 'mm'
            S)              % СКО случайного распределения
%create_channel Создаёт матрицу канала на основании его физических
%параметров и геометрическом положении. Возвращает линейны массив структур 
%типа ImpulseResponse количество элементов в котором равно произведению
%числа приёмных антенн на число передающих антенн, количество которых
%определяется количеством пар координат, в соответствующих параметрах
%функции.
%Например для системы из двух передающих антенн и трёх приёмных массив
%будет иметь размерность 1x6. Первый элемент массива - канал между первой
%приёмной и первой передающей антенной, второй элемент - канал между первой
%приёмной и второй передающей, третий - между первой приёмной и третьей
%передающей. Четвёртый - между второй приёмной и первой передающей, и т.д.
%Пример использования:
% a = create_channel(...
%             8,... Cluster decay
%             [4, 5],... Decay within cluster
%             [1.2, 1.4],... Impulse intervals within cluster
%             [8, 6],... Number of impulses in cluster
%             [2.128, 0.514; 2.127, 0.595],... Cluster's positions
%             [0,0; -0.941, 1.434],... Positions of Tx anttnnas
%             [0.0, 0.0;0.0, 0.8],... Positions of Rx anttnnas
%             'm',... Position units
%             0.01);% Deviation of normal random additive data

% Объявление структуры данных о кластере
Cluster = struct('Start',   0,... % Время прихода первого импульса в кластере
                 'Step',	0,... % Период прихода импульсов в кластере
                 'Time',    0,... % Массив содержащий время прихода импульсов
                 'Data',    0,... % Массив амплитуд импульсов
                 'Size',    0,... % Количество импульсов в кластере
                 'MaxTime', 0); % Время прихода последнего импульса
             
% Объявление структуры данных канала
ImpulseResponse = struct('LOS', 0,... % Прямой луч
                         'Ltime', 0,... % Время распространения
                         'Cluster', Cluster,... % Массив структур Cluster
                         'Size',    0,... % Количество кластеров в канале
                         'MaxTime', 0); % Время прихода последнего импульса

switch units
    case 'm'
        c = 3e-1; % Скорость света [м/нс]
    case 'cm'
        c = 3e1; % Скорость света [см/нс]
    case 'mm'
        c = 3e2; % Скорость света [мм/нс]
    otherwise
        display('Неправильные единицы измерения. Допустым м, см, мм.');
end

H = ImpulseResponse;
n = 0;
for ir = 1:size(Rx_pos,1)
    for it = 1:size(Tx_pos,1)
        n = n+1;
        for l = 1:size(Cl_time,2)
                D = norm(Tx_pos(it,:) - Cl_pos(l,:)) + ...
                    norm(Rx_pos(ir,:) - Cl_pos(l,:));
            start = D/c;
            step = Cl_time(l);
            H(n).Cluster(l).Start = start;
            H(n).Cluster(l).Step = step;
            for k = 1:Cl_size(l)
                time = (k-1)*step;
                H(n).Cluster(l).Time(k) = time;
                H(n).Cluster(l).Data(k) = S.*randn(1) + ...
                    exp(-start/H_decay)*exp(-time/Cl_decay(l));
            end
            H(n).Cluster(l).Size = k;
        end
        H(n).Size = l;
        D = norm(Tx_pos(it,:) - Rx_pos(ir,:));
        ltime = D/c;
        H(n).LOS = exp(-ltime/H_decay);
        H(n).Ltime = ltime;
    end
end

    for i = 1:numel(H)
        for l = 1:H(i).Size
            H(i).Cluster(l).MaxTime = max(H(i).Cluster(l).Time(end)+H(i).Cluster(l).Start);
        end
        H(i).MaxTime = max([H(i).Cluster(:).MaxTime]);
    end
end

