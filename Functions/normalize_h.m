function [H Hw Hz] = normalize_h( H, Hw, Hz )
%normalize_h Нормировка коэффициентов импульсного отклика

    H_norm = H; % Создаём копию матрицы канала
    S = zeros(1, numel(H)); % Инициализируем массив
    for i=1:numel(H) % Перебираем в цикле все каналы
       for l=1:H(i).Size % Перебираем в цикле все кластеры канала
           % Вычисляем суммы амплитуд импульсов в отклике
           S(i) = S(i) + sum(H(i).Cluster(l).Data) + H(i).LOS;
       end
    end
    norm = max(S); % Вычисляем максимальное значение
    for i=1:numel(H) % Перебираем в цикле все каналы
        H_norm(i).LOS = H(i).LOS/norm;
        for l=1:H(i).Size % Перебираем в цикле все кластеры канала
            % Нормируем значения
            H_norm(i).Cluster(l).Data = H(i).Cluster(l).Data/norm;
        end
    end
    H = H_norm;
    if nargin > 1
        Hw_norm = Hw;
        for i=1:numel(Hw)
            for l=1:Hw(i).Size
                Hw_norm(i).Cluster(l).Data = Hw(i).Cluster(l).Data/norm;
            end
        end
        Hw = Hw_norm;
        if nargin == 3
            Hz_norm = Hz;
            for i=1:numel(Hz)
                for l=1:Hz(i).Size
                    Hz_norm(i).Cluster(l).Data = Hz(i).Cluster(l).Data/norm;
                end
            end
            Hz = Hz_norm;
        end
    end
end


