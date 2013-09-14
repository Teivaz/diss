%Y2 = A_imp_resp_1;
%X = T_imp_resp_1;

c1t0 = 7.1250e-009;
c1a0 = 0.1555;
c1d = 1.5;
c1n = 7;
c1dt = 3.1e-009;
%dt = (c1dt - c1t0)/(c1n-1)
[a1, b1] = create_cluster(c1t0, c1a0, c1d, c1n, c1dt, 'delta');

semilogy(X, Y2./max(Y2), 'g');
hold on
[a, b] = find_extrems(X, Y2./max(Y2), 'max');
Pos1ids = [6:12, 13, 15:17, 21:22, 24:27, 29, 32, 34];
a = a(Pos1ids);
b = b(Pos1ids);

A_cluster_to_decode_9 = a;
T_cluster_to_decode_9 = b;
I_cluster_to_decode_9 = Pos1ids;
[A_cluster_raw_9, T_cluster_raw_9] = find_extrems(X, Y2./max(Y2), 'max');
A_imp_resp_9 = Y2;
T_imp_resp_9 = X;

it = 1;
for tmp = a1
    [c ind] = min(abs(a - tmp));
    if c < 0
        b(ind) = b(ind) - b1(it);
    end 
end

h = stem(a, b, 'fill');
set(get(h,'BaseLine'),'BaseValue',1e-3);
h = stem(a1, b1, 'rx');
set(get(h,'BaseLine'),'BaseValue',1e-3);
hold off
ylim([1e-3, 1])
xlim([0, 5e-8])

