clear all;

for n = 1:1
    file2load = ['find clusters/processing_clusters.mat'];
    load(file2load);
    file2load = ['find clusters/impulse_response.mat'];
    load(file2load);
end
%%

%for n = [6, 7, 3, 8, 9]
for n = [1:5]

if n == 1
	X = T_imp_resp_1;
	Y = A_imp_resp_1;
	A = A_cluster_to_decode_1;
	B = T_cluster_to_decode_1;
elseif n == 2
	X = T_imp_resp_2;
	Y = A_imp_resp_2;
	A = A_cluster_to_decode_2;
    
	B = T_cluster_to_decode_2;
elseif n == 3
	X = T_imp_resp_3;
	Y = A_imp_resp_3;
	A = A_cluster_to_decode_3;
	B = T_cluster_to_decode_3;
elseif n == 4
	X = T_imp_resp_4;
	Y = A_imp_resp_4;
	A = A_cluster_to_decode_4;
	B = T_cluster_to_decode_4;
elseif n == 5
	X = T_imp_resp_5;
	Y = A_imp_resp_5;
	A = A_cluster_to_decode_5;
	B = T_cluster_to_decode_5;
elseif n == 6
	X = T_imp_resp_6;
	Y = A_imp_resp_6; 
	A = A_cluster_to_decode_6;
	B = T_cluster_to_decode_6;
elseif n == 7
	X = T_imp_resp_7;
	Y = A_imp_resp_7;
	A = A_cluster_to_decode_7;
	B = T_cluster_to_decode_7;
elseif n == 8
	X = T_imp_resp_8;
	Y = A_imp_resp_8;
	A = A_cluster_to_decode_8;
	B = T_cluster_to_decode_8;
elseif n == 9
	X = T_imp_resp_9;
	Y = A_imp_resp_9;
	A = A_cluster_to_decode_9;
	B = T_cluster_to_decode_9;
end

c1t = [5.562e-009:0.4375e-9:8e-9];

c1t0 = 10.562e-009;
c1a0 = 0.11483;
c1d = 1;
c1n = 4;
c1dt = 1.45e-009;
%dt = (c1dt - c1t0)/(c1n-1)
[a1, b1] = create_cluster(c1t(n), c1a0, c1d, c1n, c1dt, 'delta');

semilogy(X, Y./max(Y), 'g');
hold on

it = 1;
for tmp = a1
    [c ind] = min(abs(A - tmp));
    if c < 0
        B(ind) = B(ind) - b1(it);
    end 
end

c2t0 = 10.25e-009;
c2t = [10.25e-009:2.3450e-010:2e-8];
c2a0 = 0.24912;
c2d = 1;
c2n = 4;

c2dt = 3.2e-009/2;
[a2, b2] = create_cluster(c2t(n), c2a0, c2d, c2n, c2dt, 'delta');

it = 1;
for tmp = a2
    [c ind] = min(abs(A - tmp));
    if c < 0
        B(ind) = B(ind) - b2(it);
    end 
end


h = stem(A, B, 'fill');
set(get(h,'BaseLine'),'BaseValue',1e-3);
h = stem(a1, b1, 'rx');
set(get(h,'BaseLine'),'BaseValue',1e-3);
h = stem(a2, b2, 'kx');
set(get(h,'BaseLine'),'BaseValue',1e-3);
hold off
ylim([1e-3, 1])
xlim([0, 5e-8])
drawnow;
pause(0.9)
end
%%

A_cluster_to_decode_4 = [A_cluster_to_decode_4, cursor_info.Position(1)];
T_cluster_to_decode_4 = [T_cluster_to_decode_4, cursor_info.Position(2)];

