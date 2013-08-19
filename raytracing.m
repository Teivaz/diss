
Tx = [+4.0, +3.5, 0.85];    % [x, y] Transmitter
Rx = [+6.3, +3.4, 0.85];    % [x, y] Receiever
% Walls
L1 = [+0.0, +1.0, +6.0];    % [A, B, C] -> Ax + By + C = 0
L2 = [+1.0, +0.0, +7.0];    % [A, B, C] -> Ax + By + C = 0
L3 = [+0.0, +1.0, +0.0];    % [A, B, C] -> Ax + By + C = 0
L4 = [+1.0, +0.0, +0.0];    % [A, B, C] -> Ax + By + C = 0
% Obstacles
L5 = [+0.0, +1.0, +5.2];    % [A, B, C] -> Ax + By + C = 0
L6 = [+0.0, +1.0, +0.8];    % [A, B, C] -> Ax + By + C = 0
% Floor
L7 = [+0.0, +1.0, +0.0];    % [A, B, C] -> Ax + By + C = 0
L8 = [+0.0, +1.0, +5.0];    % [A, B, C] -> Ax + By + C = 0


walls = [L1; L2; L3; L4; L5; L6];
floor = [L7; L8];
p = 0:0.1:7;
SOL = 3e8;

figure(1);
scatter(Tx(1), Tx(2));
hold on;
scatter(Rx(1), Rx(2));

len = norm(Rx - Tx);
cosAngle = 1;
for L = walls'
    TxP = ProjectionPoint(Tx, L);
    RxP = ProjectionPoint(Rx, L);
    k = norm(RxP - Rx(1:2))/norm(TxP - Tx(1:2));
    l = norm(TxP - RxP);
    direction = (RxP - TxP)/l;
    %Reflection Point
    Rp = TxP + direction*(l/(k+1));
    path = norm(Tx(1:2) - Rp) + norm(Rp - Rx(1:2));
    len = [len, path];
    [X, Y] = ToParamteric(L, p);
    %Angle
    aSq = (Rx(1) - Tx(1))^2 + (Rx(2) - Tx(2))^2;
    b = norm(Tx(1:2) - Rp);
    c = norm(Rp - Rx(1:2));
    cosAngle = [cosAngle, -(aSq - b^2 - c^2)/(4*b*c)];
    
    plot(X, Y, 'k');
    scatter(Rp(1), Rp(2), 'r', 'filled');
    %scatter(RxP(1), RxP(2), 'b', 'filled');
    %scatter(TxP(1), TxP(2), 'b', 'filled');
    
end
for L = floor'
    tx = [0.0, Tx(3)];
    aSq = (Rx(1) - Tx(1))^2 + (Rx(2) - Tx(2))^2;
    los = sqrt(aSq);
    rx = [los, Rx(3)];
    
    TxP = ProjectionPoint(tx, L);
    RxP = ProjectionPoint(rx, L);
    k = norm(RxP - rx)/norm(TxP - tx);
    l = norm(TxP - RxP);
    direction = (RxP - TxP)/l;
    %Reflection Point
    Rp = TxP + direction*(l/(k+1));
    path = norm(tx - Rp) + norm(Rp - rx);
    len = [len, path];
    [X, Y] = ToParamteric(L, p);
    %Angle
    b = norm(Tx(1:2) - Rp);
    c = norm(Rp - Rx(1:2));
    cosAngle = [cosAngle, (b^2 + c^2 - aSq)/(4*b*c)];
    
    plot(X, Y, '--b');
    scatter(Rp(1), Rp(2), 'r', 'filled');
end

hold off;
xlim([-0.1, 7.1]);
ylim([-0.1, 6.1]);
figure(2);

pow0 = 1;
alpha = 2;
sinAngle = sqrt(1 - cosAngle.^2);

n1 = 1; n2 = 9;
%Snell's law
sinAngle2 = sinAngle.*n1./n2;
cosAngle2 = sqrt(1 - sinAngle2.^2);
%Fresnel's formula
Q = (n1.*cosAngle - n2.*cosAngle2)./(n1.*cosAngle + n2.*cosAngle2);

powDecay = Q.^2.*pow0./(len.^(alpha));
time = len/SOL*1e9;

powDecay = powDecay./max(powDecay);
%scatter(time, powDecay);
plot(time, powDecay, 'or')
hold on;
ex1_time = h14(:,1);
ex1_ampl = h14(:,2);
ex1_ampl = ex1_ampl./max(ex1_ampl);
plot(ex1_time, ex1_ampl, 'x');
% ex1_time = h13(:,1);
% ex1_ampl = h13(:,2);
% ex1_ampl = ex1_ampl./max(ex1_ampl);
% plot(ex1_time, ex1_ampl, 'xg');
% ex1_time = h24(:,1);
% ex1_ampl = h24(:,2);
% ex1_ampl = ex1_ampl./max(ex1_ampl);
% plot(ex1_time, ex1_ampl, 'xb');
% ex1_time = h23(:,1);
% ex1_ampl = h23(:,2);
% ex1_ampl = ex1_ampl./max(ex1_ampl);
% plot(ex1_time, ex1_ampl, 'xk');
hold off;

%%
%--------------------
L = L2;

TxP = ProjectionPoint(Tx, L);
RxP = ProjectionPoint(Rx, L);
k = norm(RxP - Rx)/norm(TxP - Tx);
l = norm(TxP - RxP);
normal = (RxP - TxP)/l;
%Reflection Point
Rp = TxP + normal.*(l/(k+1)); 

%--------------------
% Parametric equation
p = 0:0.1:7;
[X, Y] = ToParamteric(L, p);

scatter(X, Y, '+');
hold on;
scatter(Tx(1), Tx(2), 'd');
scatter(Rx(1), Rx(2));
scatter(Rp(1), Rp(2));
hold off;
%x = 0:0.1:7;
%y = 0:0.1:6;


