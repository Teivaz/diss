
c1t0 = 7.1250e-009;
c1a0 = 0.1555;
c1d = 1.3;
c1n = 7;
c1dt = 1.5626e-009;
%dt = (c1dt - c1t0)/(c1n-1)
[a1, b1] = create_cluster(c1t0, c1a0, c1d, c1n, c1dt, 'delta');

semilogy(X, Y2./max(Y2), 'g');
hold on
[a, b] = find_extrems(X, Y2./max(Y2));
h = stem(a, b, 'fill');
set(get(h,'BaseLine'),'BaseValue',1e-3);
h = stem(a1, b1, 'rx');
set(get(h,'BaseLine'),'BaseValue',1e-3);
hold off
ylim([1e-3, 1])
xlim([0, 5e-8])

