SOL = 3e8;

% Positions
TX = [1.001, 3.0, 0.85];
RX1 = [1.0, 2.2, 0.85];
RX2 = [1.0, 2.1, 0.85];
RX3 = [1.0, 2.0, 0.85];
RX4 = [1.0, 1.9, 0.85];
RX5 = [1.0, 1.8, 0.85];
RX6 = [0.8, 2.0, 0.85];
RX7 = [0.9, 2.0, 0.85];
RX8 = [1.1, 2.0, 0.85];
RX9 = [1.2, 2.0, 0.85];

POS = POS5;
RX = RX5;
% Walls
L1 = [+0.0, +1.0, +5.3, 4.5];    % [A, B, C] -> Ax + By + C = 0
L2 = [+1.0, +0.0, +5.7, 4.5];    % [A, B, C] -> Ax + By + C = 0
L3 = [+0.0, +1.0, +0.0, 4.5];    % [A, B, C] -> Ax + By + C = 0
L4 = [+1.0, +0.0, +0.0, 4.5];    % [A, B, C] -> Ax + By + C = 0
% Obstacles
L5 = [+0.0, +1.0, +4.6, 10];    % [A, B, C] -> Ax + By + C = 0
L6 = [+0.0, +1.0, +0.7, 10];    % [A, B, C] -> Ax + By + C = 0
% Floor
L7 = [+0.0, +1.0, +0.0, 4.5];    % [A, B, C] -> Ax + By + C = 0
L8 = [+0.0, +1.0, +4.6, 4.5];    % [A, B, C] -> Ax + By + C = 0

walls = [L1; L2; L3; L4; L5; L6];
%walls = [0];
floor = [L7; L8];

n1 = 0;
n2 = 1;
if size(walls, 2) > 1
    n1 = [n1, zeros(1, size(walls, 1))];
    n2 = [n2, walls(:, 4)'];
end
if size(floor, 2) > 1
    n1 = [n1, zeros(1, size(floor, 1))];
    n2 = [n2, floor(:, 4)'];
end
n1 = n1 + 1;

clear TIME;
clear POWER;

n = 1;
cmap = hsv(n);
sigma = 0.0;
ds = linspace(-0.5*sigma, 0.5*sigma, n);

figure(1);
hold off;
%img = imread('schema.png');
hold on;
%image([0, 5.7], [5.3, 0], img); 

for fooo = 1:n
    x1 = TX(1);% + ds(fooo);
    y1 = TX(2);% + ds(fooo);
    x2 = RX(1);% + ds(fooo);
    y2 = RX(2) - ds(fooo);

    Tx = [x1, y1, TX(3)];    % [x, y, h] Transmitter
    Rx = [x2, y2, RX(3)];    % [x, y, h] Receiever

    p = 0:0.1:7;

    figure(1);
    set(gcf, 'colormap', cmap);
    scatter(Tx(1), Tx(2), 50, fooo);
    hold on;
    scatter(Rx(1), Rx(2), 50, fooo);

    indc = 1;
    cosAngle = zeros(1, size(walls, 1) + size(floor, 1) + 1);
    cosAngle(indc) = 0;
    aSq = 1; % len(1)^2;    

    ind = 1;
    len = zeros(1, size(walls, 1) + size(floor, 1) + 1);
    len(ind) = norm(Rx - Tx);
    LOS = len(1);
    if size(walls, 2) > 1
        for L = walls'
            TxP = ProjectionPoint(Tx(1:2), L);
            RxP = ProjectionPoint(Rx(1:2), L);
            k = norm(RxP - Rx(1:2))/norm(TxP - Tx(1:2));
            l = norm(TxP - RxP);
            direction = (RxP - TxP)/l;
            %Reflection Point
            Rp = TxP + direction*(l/(k+1));
            path = norm(Tx(1:2) - Rp) + norm(Rp - Rx(1:2));
            ind = ind+1;
            len(ind) = path;
            [X, Y] = ToParamteric(L, p);
            %Angle
            b = norm(Tx(1:2) - Rp);
            c = norm(Rp - Rx(1:2));
            indc = indc+1;
            cosAngle(indc) = -(aSq - b^2 - c^2)/(4*b*c);

            % plot walls
            plot(X, Y, 'k');
            % plot reflection and projection points
            scatter(Rp(1), Rp(2), 'r', 'filled');
            scatter(RxP(1), RxP(2), 'b', 'filled');
            scatter(TxP(1), TxP(2), 'b', 'filled');

        end
    end
    if size(floor, 2) > 1
        for L = floor'
            tx = [0.0, Tx(3)];
            los = sqrt(aSq);
            rx = [los, Rx(3)];

            TxP = ProjectionPoint(tx, L);
            RxP = ProjectionPoint(rx, L);
            k = norm(RxP - rx)/norm(TxP - tx);
            direction = (RxP - TxP)/len(1);
            %Reflection Point
            Rp = TxP + direction*(len(1)/(k+1));
            path = norm(tx - Rp) + norm(Rp - rx);
            ind = ind+1;
            len(ind) = path;
            %[X, Y] = ToParamteric(L, p);
            %Angle
            b = norm(Tx(1:2) - Rp);
            c = norm(Rp - Rx(1:2));
            indc = indc+1;
            cosAngle(indc) = -(aSq - b^2 - c^2)/(4*b*c);

        %    plot(X, Y, '--b');
        %    scatter(Rp(1), Rp(2), 'r', 'filled');
        end
    end
    pow0 = 1;
    alpha = 1;
    sinAngle = sqrt(1 - cosAngle.^2);


    %Snell's law
    sinAngle2 = sinAngle.*n1./n2;
    cosAngle2 = sqrt(1 - sinAngle2.^2);
    %Fresnel's formula
    Q = (n1.*cosAngle - n2.*cosAngle2)./(n1.*cosAngle + n2.*cosAngle2);
    Q(1) = 1; % LOS
    
    powDecay = (Q.^2).*pow0;
    powDecay = powDecay./(len.^(alpha));
    
    time = len/SOL*1e9;
    %powDecay(1) = 0; % LOS
    
    if exist('TIME', 'var')
        TIME = [TIME; time];
    else
        TIME = time;
    end
    if exist('POWER', 'var')
        POWER = [POWER; powDecay];
    else
        POWER = powDecay;
    end
end

POWER = POWER./max(max(POWER));

%%
figure(1)
xy = ellipse([x1, y1], [x2, y2], TIME(1, 3));
plot(xy(1,:),xy(2,:));

hold off
xlim([-0.1, 6.0]);
ylim([-0.1, 5.5]);
set(gca, 'DataAspectRatio', [1, 1, 1]);


figure(2);
set(gcf, 'colormap', cmap);
hold on;
for a = 1:size(TIME, 1)
    plot(TIME(a,:), POWER(a,:), 'o', 'color', cmap(a,:))
end

% ex1_ampl = db2mag((POS1(:,2)));
% ex2_ampl = db2mag((POS2(:,2)));
ex3_ampl = db2mag((POS(:,2)));
% ex4_ampl = db2mag((POS4(:,2)));
% ex5_ampl = db2mag((POS5(:,2)));

x1 = 2.688;
x2 = 3.875;
dx = x2 - x1;

maxval = max([ex3_ampl]);%; ex2_ampl; ex3_ampl; ex4_ampl; ex5_ampl]);

figure(2);
set(gcf, 'colormap', cmap);
hold on;
% ex1_time = POS1(:,1)*1e9 - dx;
% ex1_ampl = ex1_ampl./maxval;
% plot(ex1_time, ex1_ampl, 'color', cmap(1,:));
% ex1_time = POS2(:,1)*1e9 - dx;
% ex2_ampl = ex2_ampl./maxval;
% plot(ex1_time, ex2_ampl, 'color', cmap(2,:));
ex1_time = POS(:,1)*1e9 - dx;
ex3_ampl = ex3_ampl./maxval;
plot(ex1_time, ex3_ampl, 'color', cmap(1,:));
% ex1_time = POS4(:,1)*1e9 - dx;
% ex4_ampl = ex4_ampl./maxval;
% plot(ex1_time, ex4_ampl, 'color', cmap(4,:));
% ex1_time = POS5(:,1)*1e9 - dx;
% ex5_ampl = ex5_ampl./maxval;
% plot(ex1_time, ex5_ampl, 'color', cmap(5,:));

hold off;
xlim([0, 40]);
set(gca, 'XTick', 0:40);
set(gca, 'YScale', 'log');
grid;

