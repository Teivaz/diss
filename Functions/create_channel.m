function [H] = create_channel(...
            H_decay,...     % ����������� ��������� �������� ���������
            Cl_decay,...    % ������������ ��������� �������� � ���������
            Cl_time,...     % ��������� ������� ��������� � ��������� [��]
            Cl_size,...     % ���������� ��������� � ���������
            Cl_pos,...      % ���������� ���������
            Tx_pos,...      % ���������� �����������
            Rx_pos,...      % ���������� ��������
            units,...       % ����������� ���������� 'm', 'cm', 'mm'
            S)              % ��� ���������� �������������
%create_channel ������ ������� ������ �� ��������� ��� ����������
%���������� � �������������� ���������. ���������� ������� ������ �������� 
%���� ImpulseResponse ���������� ��������� � ������� ����� ������������
%����� ������� ������ �� ����� ���������� ������, ���������� �������
%������������ ����������� ��� ���������, � ��������������� ����������
%�������.
%�������� ��� ������� �� ���� ���������� ������ � ��� ������� ������
%����� ����� ����������� 1x6. ������ ������� ������� - ����� ����� ������
%������� � ������ ���������� ��������, ������ ������� - ����� ����� ������
%������� � ������ ����������, ������ - ����� ������ ������� � �������
%����������. �������� - ����� ������ ������� � ������ ����������, � �.�.
%������ �������������:
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

% ���������� ��������� ������ � ��������
Cluster = struct('Start',   0,... % ����� ������� ������� �������� � ��������
                 'Step',	0,... % ������ ������� ��������� � ��������
                 'Time',    0,... % ������ ���������� ����� ������� ���������
                 'Data',    0,... % ������ �������� ���������
                 'Size',    0,... % ���������� ��������� � ��������
                 'MaxTime', 0); % ����� ������� ���������� ��������
             
% ���������� ��������� ������ ������
ImpulseResponse = struct('LOS', 0,... % ������ ���
                         'Ltime', 0,... % ����� ���������������
                         'Cluster', Cluster,... % ������ �������� Cluster
                         'Size',    0,... % ���������� ��������� � ������
                         'MaxTime', 0); % ����� ������� ���������� ��������

switch units
    case 'm'
        c = 3e-1; % �������� ����� [�/��]
    case 'cm'
        c = 3e1; % �������� ����� [��/��]
    case 'mm'
        c = 3e2; % �������� ����� [��/��]
    otherwise
        display('������������ ������� ���������. �������� �, ��, ��.');
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

