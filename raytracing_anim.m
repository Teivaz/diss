SOL = 2.998e8;

UseLos = 0;
% Walls
L1 = [+0.0, +1.0, +5.3, 4.5];    % [A, B, C] -> Ax + By + C = 0
L2 = [+1.0, +0.0, +5.7, 4.5];    % [A, B, C] -> Ax + By + C = 0
L3 = [+0.0, +1.0, +0.0, 4.5];    % [A, B, C] -> Ax + By + C = 0
L4 = [+1.0, +0.0, +0.0, 4.5];    % [A, B, C] -> Ax + By + C = 0
% Obstacles
L5 = [+0.0, +1.0, +5.0, 10];    % [A, B, C] -> Ax + By + C = 0
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

n = 5;
cmap = hsv(n);
sigma = 0.4;
ds = linspace(sigma - 0.5*sigma, sigma + 0.5*sigma, n);
for fooo = 1:n
    sigma = 0.15;
    y1_ = 3.0;
    x1_ = 1.0;
    y2_ = 3.4;
    x2_ = 1.0;
    x1 = x1_;% + ds(fooo);
    x2 = x2_;% + ds(fooo);
    y1 = y1_ + ds(fooo);
    y2 = y2_;% + ds(fooo);



    Tx = [x1, y1, 0.85];    % [x, y, h] Transmitter
    Rx = [x2, y2, 0.85];    % [x, y, h] Receiever

    p = 0:0.1:7;

    figure(1);
    set(gcf, 'colormap', cmap);
    scatter(Tx(1), Tx(2), 50, fooo);
    hold on;
    scatter(Rx(1), Rx(2), 50, fooo);

    indc = 1;
    cosAngle = zeros(1, size(walls, 1));
    cosAngle(indc) = 0;
    aSq = 1; % len(1)^2;    

    ind = 1;
    len = zeros(1, size(walls, 1));
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

            plot(X, Y, 'k');
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
    %hold off;
    xlim([-0.1, 6.0]);
    ylim([-0.1, 5.5]);
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
    Q(1) = 1; % LOS
    
    powDecay = (Q.^2).*pow0;
    powDecay = powDecay./(len.^(alpha));
    
    time = len/SOL*1e9;
    powDecay(1) = 0; % LOS
    %scatter(time, powDecay);

    maxval = max(powDecay);
    powDecay = powDecay./maxval;
    plot(time, powDecay, 'o', 'color', cmap(fooo,:))
    hold on;
    drawnow;
end
    ex1_ampl = 10.^(1./(POS1(:,2)));
    ex2_ampl = 10.^(1./(POS2(:,2)));
    ex3_ampl = 10.^(1./(POS3(:,2)));
    ex4_ampl = 10.^(1./(POS4(:,2)));
    
    maxval = max([ex1_ampl; ex2_ampl; ex3_ampl; ex4_ampl]);
    ex1_time = POS1(:,1)*1e9;
    ex1_ampl = ex1_ampl./maxval;
    plot(ex1_time, ex1_ampl, 'r');
    ex1_time = POS2(:,1)*1e9;
    ex2_ampl = ex2_ampl./maxval;
    plot(ex1_time, ex2_ampl, 'g');
    ex1_time = POS3(:,1)*1e9;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl, 'b');
    ex1_time = POS4(:,1)*1e9;
    ex4_ampl = ex4_ampl./maxval;
    plot(ex1_time, ex4_ampl, 'k');
    hold off;

    hold off;

