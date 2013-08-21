Y = POS1(:,2);
Y = db2mag(0.5.*Y);
Y = Y./max(Y);

x1 = 2.688;
x2 = 3.875;
dx = x2 - x1;
X = POS1(:,1) + dx;

plot(X, Y)