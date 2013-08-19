SOL = 3e8;

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

%walls = [L1; L2; L3; L4; L5; L6];
walls = [L3; L6; L1; L5];
%floor = [L7; L8];
floor = [L7];

n1 = linspace(1,1,9);
n2 = [1, linspace(4.5,4.5, 4), linspace(10, 10, 2), linspace(4.5,4.5, 2)];

n = 10;
cmap = hsv(n);
sigma = 0.5;
ds = linspace(sigma - 0.5*sigma, sigma + 0.5*sigma, n);
for fooo = 1:n
    sigma = 0.15;
    y1_ = 3.5;
    x1_ = 4.0;
    y2_ = 3.4;
    x2_ = 6.3;
    x1 = x1_ + ds(fooo);
    x2 = x2_ ;%+ ds(fooo);
    y1 = y1_ + ds(fooo);
    y2 = y2_ ;%+ ds(fooo);



Tx = [x1, y1, 0.85];    % [x, y, h] Transmitter
Rx = [x2, y2, 0.85];    % [x, y, h] Receiever

p = 0:0.1:7;

figure(1);
set(gcf, 'colormap', cmap);
scatter(Tx(1), Tx(2), 50, fooo);
hold on;
scatter(Rx(1), Rx(2), 50, fooo);

indc = 1;
cosAngle = zeros(1, 9);
cosAngle(indc) = 0;
aSq = 1; % len(1)^2;

ind = 1;
len = zeros(1, 9);
len(ind) = norm(Rx - Tx);
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
    
    plot(X, Y, 'k');
    scatter(Rp(1), Rp(2), 'r', 'filled');
    scatter(RxP(1), RxP(2), 'b', 'filled');
    scatter(TxP(1), TxP(2), 'b', 'filled');
    
end
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

%hold off;
xlim([-0.1, 7.1]);
ylim([-0.1, 6.1]);
figure(2);
set(gcf, 'colormap', cmap);
hold on;
pow0 = 1;
alpha = 2;
sinAngle = sqrt(1 - cosAngle.^2);


%Snell's law
sinAngle2 = sinAngle.*n1./n2;
cosAngle2 = sqrt(1 - sinAngle2.^2);
%Fresnel's formula
Q = (n1.*cosAngle - n2.*cosAngle2)./(n1.*cosAngle + n2.*cosAngle2);

powDecay = (Q.^2).*pow0./(len.^(alpha));
time = len/SOL*1e9;
%powDecay(1) = 0;
%scatter(time, powDecay);

powDecay = powDecay./max(powDecay, 1);
plot(time, powDecay, 'o', 'color', cmap(fooo,:))
hold on;
ex1_time = h14(:,1);
ex1_ampl = h14(:,2);
ex1_ampl = ex1_ampl./max(ex1_ampl);
plot(ex1_time, ex1_ampl, 'kx');
hold off;

drawnow;
hold off;
end

