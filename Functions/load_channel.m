function [H Hw Hz] = load_channel()
%load_channel Загружает измеренные данные канала связи

% Объявление структуры данных о кластере
Cluster = struct('Start', 0,... % Время прихода первого импульса в кластере
                 'Step', 0,... % Период прихода импульсов в кластере
                 'Time', 0,... % Массив содержащий время прихода импульсов
                 'Data', 0,... % Массив амплитуд импульсов
                 'Size', 0,... % Количество импульсов в кластере
                 'MaxTime', 0); % Время прихода последнего импульса
             
% Объявление структуры данных канала
ImpulseResponse = struct('LOS', 0,... % Прямой луч
                         'Ltime', 0,... % Время распространения
                         'Cluster', Cluster,... % Массив структур Cluster
                         'Size',0,... % Количество кластеров в канале
                         'MaxTime', 0); % Время прихода последнего импульса

% H11 (2-3)
h11_los = 1374;
h11_ltime = 7.38;
h11_c1 = [685.6 893.6 338.2 373.9 0 297.3];
bgn11_c1 = 9.58;
stp11_c1 = 1.3;
h11_c2 = [422.6 297.8 167.4 230.8 266];
bgn11_c2 = 17.45;
stp11_c2 = 1.15;
h11_c3 = [372.2 488.8 311.3 324.6 0 372.4 180.4];
bgn11_c3 = 23.25;
stp11_c3 = 1.65;

% H12 (1-3)
h12_los = 1276;
h12_ltime = 7.28;
h12_c1 = [529.8 492.4 267.6 357.6 362.6 455];
bgn12_c1 = 9.42;
stp12_c1 = 1.14;
h12_c2 = [263.7 219.8 227.42 221.5];
bgn12_c2 = 17.51;
stp12_c2 = 1.51;
h12_c3 = [496.5	329.4 233.3 263.3 196.4 0 234.5 237.2 259.9];
bgn12_c3 = 23.83;
stp12_c3 = 0.98;

% H21 (2-4)
h21_los = 1314;
h21_ltime = 7.28;
h21_c1 = [321.8 437.7 0 524.3 245 610.8];
bgn21_c1 = 8.94;
stp21_c1 = 1.2;
h21_c2 = [216 392.9 0 295.3];
bgn21_c2 = 16.85;
stp21_c2 = 1.6;
h21_c3 = [472.4 265 0 268 260.1 264.4];
bgn21_c3 = 22.36;
stp21_c3 = 1.79;

% H22 (1-4)
h22_los = 1287;
h22_ltime = 7.22;
h22_c1 = [617.4 228 545.3 254.7 231.5];
bgn22_c1 = 9.35;
stp22_c1 = 1.8;
h22_c2 = [338.8 312.7 0 297.7];
bgn22_c2 = 17.99;
stp22_c2 = 1.7;
h22_c3 = [422.9 0 264.2 204.1];
bgn22_c3 = 24.75;
stp22_c3 = 2.3;

%% Hw1 (4-5)
hw11_c1 = [907.2 286.1 914.8 215.8];
bgnw11_c1 = 11.24;
stpw11_c1 = 1.95;
hw11_c2 = [463.9 208.9 231.7];
bgnw11_c2 = 19.24;
stpw11_c2 = 3.1;
hw11_c3 = [259.9 229.1 233.9 200.1 192.7 156.5 140.7];
bgnw11_c3 = 26;
stpw11_c3 = 1;

% Hw2 (3-5)
hw12_c1 = [1038 349 732 263.2];
bgnw12_c1 = 11.24;
stpw12_c1 = 1.6;
hw12_c2 = [308.7 217.9 270.2];
bgnw12_c2 = 17.39;
stpw12_c2 = 1.9;
hw12_c3 = [199.5 208.1 163.2 0 309.2];
bgnw12_c3 = 28.48;
stpw12_c3 = 1.5;

%% Hz1 (1-5)
hz11_c1 = [2757 2296 711.9 711.1 436.1 0 373 313.9];
bgnz11_c1 = 5.5;
stpz11_c1 = 1.5;
hz11_c2 = [405.8 277.2 0 201.2 308.2];
bgnz11_c2 = 16.21;
stpz11_c2 = 2.48;
hz11_c3 = [268.4 83.12];
bgnz11_c3 = 30.14;
stpz11_c3 = 1.3;

% Hz2 (2-5)
hz12_c1 = [2730 1475 581.2 489.9 342.3 238.4 234.4];
bgnz12_c1 = 5.72;
stpz12_c1 = 1.85;
hz12_c2 = [501.3 274 426.1 0 203];
bgnz12_c2 = 16.43;
stpz12_c2 = 1.4;
hz12_c3 = [256.7 208.3 154 127.2 57.37];
bgnz12_c3 = 24.3;
stpz12_c3 = 1.8;

%% Присваиваем значение элементам структуры основного канала
H = ImpulseResponse;
time = @(step, data)(0:step:(step*(numel(data)-1)));
% Канал Н11
i = 1;
    H(i).Size = 3;
    H(i).LOS = h11_los;
    H(i).Ltime = h11_ltime;
    l = 1;  % Первый кластер
        H(i).Cluster(l).Data = h11_c1;
        H(i).Cluster(l).Start = bgn11_c1;
        H(i).Cluster(l).Step = stp11_c1;
        H(i).Cluster(l).Time = time(stp11_c1, h11_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2; % Второй кластер
        H(i).Cluster(l).Data = h11_c2;
        H(i).Cluster(l).Start = bgn11_c2;
        H(i).Cluster(l).Step = stp11_c2;
        H(i).Cluster(l).Time = time(stp11_c2, h11_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3; % Третий кластер
        H(i).Cluster(l).Data = h11_c3;
        H(i).Cluster(l).Start = bgn11_c3;
        H(i).Cluster(l).Step = stp11_c3;
        H(i).Cluster(l).Time = time(stp11_c3, h11_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
% Канал Н12
i = 2;
    H(i).Size = 3;
    H(i).LOS = h12_los;
    H(i).Ltime = h12_ltime;
    l = 1; % Первый кластер
        H(i).Cluster(l).Data = h12_c1;
        H(i).Cluster(l).Start = bgn12_c1;
        H(i).Cluster(l).Step = stp12_c1;
        H(i).Cluster(l).Time = time(stp12_c1, h12_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2; % Второй кластер
        H(i).Cluster(l).Data = h12_c2;
        H(i).Cluster(l).Start = bgn12_c2;
        H(i).Cluster(l).Step = stp12_c2;
        H(i).Cluster(l).Time = time(stp12_c2, h12_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3; % Третий кластер
        H(i).Cluster(l).Data = h12_c3;
        H(i).Cluster(l).Start = bgn12_c3;
        H(i).Cluster(l).Step = stp12_c3;
        H(i).Cluster(l).Time = time(stp12_c3, h12_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
% Канал Н21
i = 3;
    H(i).Size = 3;
    H(i).LOS = h21_los;
    H(i).Ltime = h21_ltime;
    l = 1; % Первый кластер
        H(i).Cluster(l).Data = h21_c1;
        H(i).Cluster(l).Start = bgn21_c1;
        H(i).Cluster(l).Step = stp21_c1;
        H(i).Cluster(l).Time = time(stp21_c1, h21_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2; % Второй кластер
        H(i).Cluster(l).Data = h21_c2;
        H(i).Cluster(l).Start = bgn21_c2;
        H(i).Cluster(l).Step = stp21_c2;
        H(i).Cluster(l).Time = time(stp21_c2, h21_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3; % Третий кластер
        H(i).Cluster(l).Data = h21_c3;
        H(i).Cluster(l).Start = bgn21_c3;
        H(i).Cluster(l).Step = stp21_c3;
        H(i).Cluster(l).Time = time(stp21_c3, h21_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
% Канала Н22
i = 4;
    H(i).Size = 3;
    H(i).LOS = h22_los;
    H(i).Ltime = h22_ltime;
    l = 1; % Первый кластер
        H(i).Cluster(l).Data = h22_c1;
        H(i).Cluster(l).Start = bgn22_c1;
        H(i).Cluster(l).Step = stp22_c1;
        H(i).Cluster(l).Time = time(stp22_c1, h22_c1);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 2; % Второй кластер
        H(i).Cluster(l).Data = h22_c2;
        H(i).Cluster(l).Start = bgn22_c2;
        H(i).Cluster(l).Step = stp22_c2;
        H(i).Cluster(l).Time = time(stp22_c2, h22_c2);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
    l = 3; % Третий кластер
        H(i).Cluster(l).Data = h22_c3;
        H(i).Cluster(l).Start = bgn22_c3;
        H(i).Cluster(l).Step = stp22_c3;
        H(i).Cluster(l).Time = time(stp22_c3, h22_c3);
        H(i).Cluster(l).Size = numel(H(i).Cluster(l).Data);
for i = 1:numel(H)
    for l = 1:H(i).Size
        H(i).Cluster(l).MaxTime = max(H(i).Cluster(l).Time(end)+H(i).Cluster(l).Start);
    end
    H(i).MaxTime = max([H(i).Cluster(:).MaxTime]);
end
%% Присваиваем значение элементам структуры отводного канала
% Канал Hw1
Hw = ImpulseResponse;
i = 1;
    Hw(i).Size = 3;
    l = 1; % Первый кластер
        Hw(i).Cluster(l).Data = hw11_c1;
        Hw(i).Cluster(l).Start = bgnw11_c1;
        Hw(i).Cluster(l).Step = stpw11_c1;
        Hw(i).Cluster(l).Time = time(stpw11_c1, hw11_c1);
        Hw(i).Cluster(l).Size = numel(Hw(i).Cluster(l).Data);
    l = 2; % Второй кластер
        Hw(i).Cluster(l).Data = hw11_c2;
        Hw(i).Cluster(l).Start = bgnw11_c2;
        Hw(i).Cluster(l).Step = stpw11_c2;
        Hw(i).Cluster(l).Time = time(stpw11_c2, hw11_c2);
        Hw(i).Cluster(l).Size = numel(Hw(i).Cluster(l).Data);
    l = 3; % Третий кластер
        Hw(i).Cluster(l).Data = hw11_c3;
        Hw(i).Cluster(l).Start = bgnw11_c3;
        Hw(i).Cluster(l).Step = stpw11_c3;
        Hw(i).Cluster(l).Time = time(stpw11_c3, hw11_c3);
        Hw(i).Cluster(l).Size = numel(Hw(i).Cluster(l).Data);
% Канал Hw2
i = 2;
    Hw(i).Size = 3;
    l = 1; % Первый кластер
        Hw(i).Cluster(l).Data = hw12_c1;
        Hw(i).Cluster(l).Start = bgnw12_c1;
        Hw(i).Cluster(l).Step = stpw12_c1;
        Hw(i).Cluster(l).Time = time(stpw12_c1, hw12_c1);
        Hw(i).Cluster(l).Size = numel(Hw(i).Cluster(l).Data);
    l = 2; % Второй кластер
        Hw(i).Cluster(l).Data = hw12_c2;
        Hw(i).Cluster(l).Start = bgnw12_c2;
        Hw(i).Cluster(l).Step = stpw12_c2;
        Hw(i).Cluster(l).Time = time(stpw12_c2, hw12_c2);
        Hw(i).Cluster(l).Size = numel(Hw(i).Cluster(l).Data);
    l = 3; % Третий кластер
        Hw(i).Cluster(l).Data = hw12_c3;
        Hw(i).Cluster(l).Start = bgnw12_c3;
        Hw(i).Cluster(l).Step = stpw12_c3;
        Hw(i).Cluster(l).Time = time(stpw12_c3, hw12_c3);
        Hw(i).Cluster(l).Size = numel(Hw(i).Cluster(l).Data);
for i = 1:numel(Hw)
    for l = 1:Hw(i).Size
        Hw(i).Cluster(l).MaxTime = max(Hw(i).Cluster(l).Time(end)+Hw(i).Cluster(l).Start);
    end
    Hw(i).MaxTime = max([Hw(i).Cluster(:).MaxTime]);
end
%% Присваиваем значение элементам структуры канала воздействия помехи
% Канал Hz1
Hz = ImpulseResponse;
i = 1;
    Hz(i).Size = 3;
    l = 1; % Первый кластер
        Hz(i).Cluster(l).Data = hz11_c1;
        Hz(i).Cluster(l).Start = bgnz11_c1;
        Hz(i).Cluster(l).Step = stpz11_c1;
        Hz(i).Cluster(l).Time = time(stpz11_c1, hz11_c1);
        Hz(i).Cluster(l).Size = numel(Hz(i).Cluster(l).Data);
    l = 2; % Второй кластер
        Hz(i).Cluster(l).Data = hz11_c2;
        Hz(i).Cluster(l).Start = bgnz11_c2;
        Hz(i).Cluster(l).Step = stpz11_c2;
        Hz(i).Cluster(l).Time = time(stpz11_c2, hz11_c2);
        Hz(i).Cluster(l).Size = numel(Hz(i).Cluster(l).Data);
    l = 3; % Третий кластер
        Hz(i).Cluster(l).Data = hz11_c3;
        Hz(i).Cluster(l).Start = bgnz11_c3;
        Hz(i).Cluster(l).Step = stpz11_c3;
        Hz(i).Cluster(l).Time = time(stpz11_c3, hz11_c3);
        Hz(i).Cluster(l).Size = numel(Hz(i).Cluster(l).Data);
% Канал Hz2
i = 2;
    Hz(i).Size = 3;
    l = 1;
        Hz(i).Cluster(l).Data = hz12_c1;
        Hz(i).Cluster(l).Start = bgnz12_c1;
        Hz(i).Cluster(l).Step = stpz12_c1;
        Hz(i).Cluster(l).Time = time(stpz12_c1, hz12_c1);
        Hz(i).Cluster(l).Size = numel(Hz(i).Cluster(l).Data);
    l = 2; % Второй кластер
        Hz(i).Cluster(l).Data = hz12_c2;
        Hz(i).Cluster(l).Start = bgnz12_c2;
        Hz(i).Cluster(l).Step = stpz12_c2;
        Hz(i).Cluster(l).Time = time(stpz12_c2, hz12_c2);
        Hz(i).Cluster(l).Size = numel(Hz(i).Cluster(l).Data);
    l = 3; % Третий кластер
        Hz(i).Cluster(l).Data = hz12_c3;
        Hz(i).Cluster(l).Start = bgnz12_c3;
        Hz(i).Cluster(l).Step = stpz12_c3;
        Hz(i).Cluster(l).Time = time(stpz12_c3, hz12_c3);
        Hz(i).Cluster(l).Size = numel(Hz(i).Cluster(l).Data);
for i = 1:numel(Hz)
    for l = 1:Hz(i).Size
        Hz(i).Cluster(l).MaxTime = max(Hz(i).Cluster(l).Time(end)+Hz(i).Cluster(l).Start);
    end
    Hz(i).MaxTime = max([Hz(i).Cluster(:).MaxTime]);
end
end

