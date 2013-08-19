function [ output ] = propagation( channel, input )
% propagation input - timeseries; channel - ImpulseResponse array size 1xL;
%   Detailed explanation goes here
output = input;
output.Data = output.Data*0;
times = input.Time;
for l=1:channel.Size
    step = channel.Cluster(l).Step;
    last = input.Time(end);
    input_tmp = resample(input, 0:step:last);
    result_tmp = filter(input_tmp, channel.Cluster(l).Data, 1);
    result_tmp.Time = channel.Cluster(l).Start + result_tmp.Time;
    result = resample(result_tmp, times);
    output.Data = output.Data + result.Data;
end
end
