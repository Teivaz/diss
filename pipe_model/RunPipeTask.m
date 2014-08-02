function [result] = RunPipeTask(pipeTask)
	% function starts 2d room raytracing, then converts impulse responses to set of clusters,
	% then runs throug MIMO system virtually located in the room described in step 1 and 
	% evaluates BER

    for path_i = 1:4
        if isfield(pipeTask, 'traceTask')
    		traceResultArr = Trace(pipeTask.traceTask(path_i));

            traceResult = struct('time', traceResultArr(1, :), 'value', traceResultArr(2, :));
        else
            traceResult = pipeTask.traceResult(path_i);            
        end

    	synthTask = struct...
            ('hasLimits', 0 ...
            ,'traceResult', traceResult ...
            ,'fitnessLimit', 70 ...
            ,'plotProgress', 0 ...
            );
        
    	[cost(path_i), clusters] = SynthesiseCluster(synthTask);
    
        for l = 1:5
            clear Y;
            Y(1) = clusters(l).StartPower;
            number = clusters(l).Number;
            for a = 2:number
               Y(a) = Y(a-1)/clusters(l).DecayPower;
            end
            HCluster(l).Step = clusters(l).IntervalTime;
            HCluster(l).Data = Y;
            HCluster(l).Start = clusters(l).StartTime;
        end

        H(path_i).Cluster = HCluster;
        H(path_i).Size = 5;
           
    end

    %%%% Imitate digital trnsmitting system

    impulse_length = 33;  %  ƒлительность импульса 802.11b с модул€цией BPSK
                            %  и расширением спектра DSSS 11 составл€ет 16.5 нс
                            %  —корость передачи 11 мб/с

    times_step = 0.1903;
    bytes = pipeTask.packageSize;             % количество килобайт

    M = 2; % 2 for BPSK
    phi = pi/4; % Initial phase
    SNR = pipeTask.SNR;
    for snr = SNR
        ber(snr) = mimo_5(M, phi, H, bytes, snr, impulse_length, times_step);
    end;
    result = ber;
    
end