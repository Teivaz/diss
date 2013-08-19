function [H Hw Hz] = normalize_h( H, Hw, Hz )
%normalize_h ���������� ������������� ����������� �������

    H_norm = H; % ������ ����� ������� ������
    S = zeros(1, numel(H)); % �������������� ������
    for i=1:numel(H) % ���������� � ����� ��� ������
       for l=1:H(i).Size % ���������� � ����� ��� �������� ������
           % ��������� ����� �������� ��������� � �������
           S(i) = S(i) + sum(H(i).Cluster(l).Data) + H(i).LOS;
       end
    end
    norm = max(S); % ��������� ������������ ��������
    for i=1:numel(H) % ���������� � ����� ��� ������
        H_norm(i).LOS = H(i).LOS/norm;
        for l=1:H(i).Size % ���������� � ����� ��� �������� ������
            % ��������� ��������
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


