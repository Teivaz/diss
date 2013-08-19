function [delay] = get_delay ( impulse_length, times_step, H )
% Find propagtion delay

interp_hold = @(new_Time, Time, Data)interp1(Time, Data, new_Time, 'nearest', 'extrap');

test_seq = [0 1 0]';
% Формируем тестовую последовательность
max_test_time = (impulse_length*(size(test_seq)-1));
test_seq_ts = timeseries(test_seq, 0:impulse_length:max_test_time);
test_seq_ts = setinterpmethod(test_seq_ts, interp_hold);
test_seq_ts = resample(test_seq_ts, 0:times_step:max_test_time);
start_input = test_seq_ts.Time(find(test_seq_ts.Data, 1, 'first'));
delay = zeros(numel(H), 1);
for i = 1:numel(H)
    test_resp_ts = propagation(H(i), test_seq_ts);
    start_resp = test_resp_ts.Time(find(test_resp_ts.Data, 1, 'first'));
    delay(i) = start_resp - start_input;
end
end