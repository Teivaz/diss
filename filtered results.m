load -mat 'experiment2/Processed/pos.mat';

clear POS;
POS(1,:) = (POS1(19:801,2));
POS(2,:) = (POS2(19:801,2));
POS(3,:) = (POS3(19:801,2));
POS(4,:) = (POS4(19:801,2));
POS(5,:) = (POS5(19:801,2));
POS(6,:) = (POS6(19:801,2));
POS(7,:) = (POS7(19:801,2));
POS(8,:) = (POS8(19:801,2));
POS(9,:) = (POS9(19:801,2));
X = POS1(1:801, 1);

Y = db2mag(POS1(1:801, 2));

Fs = 1/(X(2) - X(1));
for a = 1:9
NFFT = 2^nextpow2(numel(Y));

x1 = 2.688;
x2 = 3.875;
dx = x2 - x1;

y = fft(Y)/numel(Y);
f = Fs/2*linspace(0, 1, NFFT/2 + 1);
%semilogy(f,2*abs(y(1:NFFT/2+1)));
%xlim([1.5e9, 4e9]);
%drawnow;
%pause(1);
end

% N = 10;
SpectrumMaskFreq = [0e6, 2402e6, 2402e6, 2412e6, 2412e6, 2432e6, 2432e6, 2442e6, 2442e6, 8000e6];
SpectrumMaskAmpl = [-50, -50, -30, -30, 0, 0, -30, -30, -50, -50];
% %
% SpectrumMaskFreq = SpectrumMaskFreq - SpectrumMaskFreq(1);
% SpectrumMaskFreq = SpectrumMaskFreq./max(SpectrumMaskFreq);
SpectrumMaskAmpl = db2mag(SpectrumMaskAmpl);
% b = firls(N, SpectrumMaskFreq, SpectrumMaskAmpl);
% plot(SpectrumMaskFreq, SpectrumMaskAmpl)
% [H, f] = freqz(b, 1, 512, 2);
% plot(f,abs(H))

for FiltDecay = 24;
%     d = fdesign.bandpass( 2402e6, 2412e6, 2432e6, 2442e6,...
%                         FiltDecay, 0.5, FiltDecay, Fs);
    d = fdesign.bandpass('n,fst1,fst2,ast', 40, 2402e6, 2442e6, 50, Fs);
    lo = fdesign.lowpass(2432e6, 2442e6, 0.5, FiltDecay, Fs);
    hi = fdesign.highpass(2402e6, 2412e6, FiltDecay, 0.5, Fs);
    hlo = design(lo, 'ellip', 'matchexactly', 'passband' );
    hhi = design(hi, 'ellip', 'matchexactly', 'passband' );

    hd = design(d);%, 'ellip');%, 'matchexactly', 'passband');
    %fvtool(hd)
    Y2 = Y;
    R = NewAmpl;
    if (0)
        Y2 = filter(hd, Y2);
        R = filter(hd, R);
    else
        Y2 = filter(hlo, Y2);
        Y2 = filter(hhi, Y2);
        R = filter(hlo, R);
        R = filter(hhi, R);
    end
    Y2 = abs(Y2);
    R = abs(R);
    figure(2)
    semilogy(X, Y2./max(Y2), 'r');
    hold on

    semilogy(NewTime, R./max(R), 'm')
    semilogy(X, Y./max(Y), 'g');
    for a = 1:size(POWER, 2)
        text( (TIME(a)+dx) * 1e-9, POWER(a)*(1.1 + 0.3*rand(1,1)), int2str(a));
%         hStem = stem( (TIME(a)+dx) * 1e-9, POWER(a));
%         hBase = get(hStem, 'Baseline');
%         set(hBase, 'BaseValue', 1e-4);
    end
    hold off
    title(['Position 1. Decay ', num2str(FiltDecay), ' [dB]'])
    ylim([1e-3, 1])
    xlim([0, 5e-8])
    %grid

    NFFT = 1024;
    f = Fs/2*linspace(0, 1, NFFT/2 + 1);
    y = fft(Y, NFFT)./numel(Y);
    y2 = fft(Y2, NFFT)./numel(Y2);
    r = fft(R, NFFT)./numel(R);
    %y = y./max(y);
    %y2 = y2./max(y2);
    figure(1)
    semilogy(f, abs(y2(1:NFFT/2+1)), 'r', f, abs(y(1:NFFT/2+1)), 'g', f, abs(r(1:NFFT/2+1)), 'b')
    %semilogy(SpectrumMaskFreq, SpectrumMaskAmpl)
    hold off
    title(['Position 1. Decay ', num2str(FiltDecay), ' [dB]'])
    %xlim([1.5e9, 4e9])
    drawnow;
    grid
    pause(0.5);
end
