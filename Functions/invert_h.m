function [ F D ] = invert_h( impulse_length, times_step, H )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
	%----------------------------
	%- Вычисление параметров фильтров
	% Requires:
	%	impulse_length, times_step, interp_cube, H,
	% Result:
	%	F
	interp_hold = @(new_Time, Time, Data)interp1(Time, Data, new_Time, 'nearest', 'extrap');	
	% Test signal    
    test_x = [0 0 1 0 0 0]';
    % Формируем тестовую последовательность
    max_test_time = (impulse_length*(size(test_x)-1));
    fil_len = floor(2*impulse_length/times_step);
    st = floor(1*impulse_length/times_step);
    en = floor(3*impulse_length/times_step);
    test_x_ts = timeseries(test_x, 0:impulse_length:max_test_time);
    test_x_ts = setinterpmethod(test_x_ts, interp_hold);
    test_x_ts = resample(test_x_ts, 0:times_step:max_test_time);
    % Calculate inverted H matrix
	F_fft_tmp = struct('Data', []);
    F = struct('Data', []); 
    start_input = test_x_ts.Time(find(test_x_ts.Data, 1, 'first'));
%    delay = get_delay(impulse_length, times_step, H);
        for i = 1:numel(H)
            test_y_ts = propagation(H(i), test_x_ts);
            start_resp = test_y_ts.Time(find(test_y_ts.Data, 1, 'first'));
            delay = start_resp - start_input;
            test_y_ts.Time = test_y_ts.Time - 1.03*delay;
            test_y_ts = resample(test_y_ts, test_x_ts.Time);
            mu = 0.0051;            % LMS step size. 
            
            ha = adaptfilt.lms(fil_len, mu); 
            d = test_x_ts.Data(st:(st+en))';
            x = test_y_ts.Data(st:(st+en))';
            filter(ha, d, x);
            F_fft_tmp(i).Data = fft(ha.coefficients);
        end
D_fft = sum( abs( F_fft_tmp(1).Data .* F_fft_tmp(4).Data) - ...
    abs(F_fft_tmp(2).Data .* F_fft_tmp(3).Data));
    F(1).Data = ifft(F_fft_tmp(4).Data ./ D_fft);
    F(2).Data = ifft( -(F_fft_tmp(2).Data) ./ D_fft );
    F(3).Data = ifft( -(F_fft_tmp(3).Data) ./ D_fft );
    F(4).Data = ifft(F_fft_tmp(1).Data ./ D_fft);
D = abs(D_fft);
end

