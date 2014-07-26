function [result] = run(pipeTask)
	% function starts 2d room raytracing, then converts impulse responses to set of clusters,
	% then runs throug MIMO system virtually located in the room described in step 1 and 
	% evaluates BER


	if pipeTask.hasTraceTask
		pipeTask.traceResult = Trace(pipeTask.traceTask);
	end
	traceResult = struct(...
        'time', pipeTask.traceResult(1, :),...
        'value', pipeTask.traceResult(2, :)...
        );

	synthTask = struct('hasLimits', 0, 'traceResult', traceResult);
	SynthesiseCluster(synthTask);

end