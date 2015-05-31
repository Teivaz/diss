function [cost, result] = SynthesiseCluster(synthTask)

if synthTask.hasLimits
	ClusterLimits = synthTask.ClusterLimits;
else
	% Limits
	ClusterLimits.StartTime = [3, 30];          % ns
	ClusterLimits.IntervalTime = [1, 15];       % ns
	ClusterLimits.StartPower = [0.05, 1];       % V
	ClusterLimits.DecayPower = [1, 10];       % 
	ClusterLimits.Number = [2, 15];              % 
end
rnd = @(a) a(1) + (a(2)-a(1)).*rand(1,1);
rndi = @(a) a(1) + randi((a(2)-a(1)),1,1);

lb = [...
	1.5,...
	ClusterLimits.IntervalTime(1),...
	1,...
	ClusterLimits.DecayPower(1),...
	1,...
	ClusterLimits.StartTime(1),...
	ClusterLimits.IntervalTime(1),...
	ClusterLimits.StartPower(1),...
	ClusterLimits.DecayPower(1),...
	ClusterLimits.Number(1),...
	ClusterLimits.StartTime(1),...
	ClusterLimits.IntervalTime(1),...
	ClusterLimits.StartPower(1),...
	ClusterLimits.DecayPower(1),...
	ClusterLimits.Number(1),...
	ClusterLimits.StartTime(1),...
	ClusterLimits.IntervalTime(1),...
	ClusterLimits.StartPower(1),...
	ClusterLimits.DecayPower(1),...
	ClusterLimits.Number(1),...
	ClusterLimits.StartTime(1),...
	ClusterLimits.IntervalTime(1),...
	ClusterLimits.StartPower(1),...
	ClusterLimits.DecayPower(1),...
	ClusterLimits.Number(1)];

ub = [...
	28,...
	ClusterLimits.IntervalTime(2),...
	1,...
	ClusterLimits.DecayPower(2),...
	1,...
	ClusterLimits.StartTime(2),...
	ClusterLimits.IntervalTime(2),...
	ClusterLimits.StartPower(2),...
	ClusterLimits.DecayPower(2),...
	ClusterLimits.Number(2),...
	ClusterLimits.StartTime(2),...
	ClusterLimits.IntervalTime(2),...
	ClusterLimits.StartPower(2),...
	ClusterLimits.DecayPower(2),...
	ClusterLimits.Number(2),...
	ClusterLimits.StartTime(2),...
	ClusterLimits.IntervalTime(2),...
	ClusterLimits.StartPower(2),...
	ClusterLimits.DecayPower(2),...
	ClusterLimits.Number(2),...
	ClusterLimits.StartTime(2),...
	ClusterLimits.IntervalTime(2),...
	ClusterLimits.StartPower(2),...
	ClusterLimits.DecayPower(2),...
	ClusterLimits.Number(2)];

clear args;
args(1)  = rnd(ClusterLimits.StartTime);   
args(2)  = rnd(ClusterLimits.IntervalTime);
args(3)  = rnd(ClusterLimits.StartPower);  
args(4)  = rnd(ClusterLimits.DecayPower);  
args(5)  = rndi(ClusterLimits.Number);     
args(6)  = rnd(ClusterLimits.StartTime);   
args(7)  = rnd(ClusterLimits.IntervalTime);
args(8)  = rnd(ClusterLimits.StartPower);  
args(9)  = rnd(ClusterLimits.DecayPower);  
args(10) = rndi(ClusterLimits.Number);     
args(11) = rnd(ClusterLimits.StartTime);   
args(12) = rnd(ClusterLimits.IntervalTime);
args(13) = rnd(ClusterLimits.StartPower);  
args(14) = rnd(ClusterLimits.DecayPower);  
args(15) = rndi(ClusterLimits.Number);     
args(16) = rnd(ClusterLimits.StartTime);   
args(17) = rnd(ClusterLimits.IntervalTime);
args(18) = rnd(ClusterLimits.StartPower);  
args(19) = rnd(ClusterLimits.DecayPower);  
args(20) = rndi(ClusterLimits.Number);     
args(21) = rnd(ClusterLimits.StartTime);   
args(22) = rnd(ClusterLimits.IntervalTime);
args(23) = rnd(ClusterLimits.StartPower);  
args(24) = rnd(ClusterLimits.DecayPower);  
args(25) = rndi(ClusterLimits.Number);     

if isfield(synthTask, 'fitnessLimit')
    FitnessLimit = synthTask.fitnessLimit;
else
    FitnessLimit = -Inf;
end

name = num2str(hash([synthTask.traceResult.time synthTask.traceResult.value]));
loaded_result = load_optimized(name);


if isfield(loaded_result, 'cost') && (loaded_result.cost <= FitnessLimit)
    result_raw = loaded_result.result_raw;
    cost = loaded_result.cost;
else
    if isfield(synthTask, 'plotProgress') && synthTask.plotProgress ~= 0
        PlotFcns = @(options, state, flag)PlotClusters(synthTask.traceResult, options, state, flag);
    else
        PlotFcns = @(options, state, flag)0;
    end

    if 0
        %%% GENETIC ALGORITHM
        %gaOpt = gaoptimset('PlotFcns', @gaplotbestfun, 'PlotInterval', 5, 'PopInitRange', [lb; ub]);
        gaOpt = gaoptimset( ...
                            'PlotFcns', PlotFcns,...
                            'PlotInterval', 10,...
                            'PopInitRange', [lb; ub],...
                            'PopulationSize', 100,...
                            'EliteCount', 6,...
                            'TolFun', 0,...
                            'PopulationType', 'doubleVector',... 
                            'Generations', 1000,...
                            'CrossoverFraction', 0.53,...
                            'FitnessLimit', FitnessLimit...
                            );

        if exist('population')
            gaOpt.InitialPopulation = population;
        end

        fitness = @(args)CostStraightCompare(synthTask.traceResult, args);

        n = 1;
        for a = 1:n
            [result_raw, cost, exitflag, output, population] = ga(fitness, numel(args), [], [], [], [], lb, ub, [], gaOpt);
            gaOpt.InitialPopulation = population;
        end

    else
        %%% PSO ALGORITHM

        fitness = @(args)CostStraightCompare(synthTask.traceResult, args);
        Pdef = [1 4 8 2 2 0.9 0.4 20 1e-25 250 NaN 0 0];

        pltFcn = '';

        [optOut, tr, te] = pso_Trelea_vectorized(fitness, numel(args), ub, [lb; ub]', 0, Pdef);

        result_raw = optOut(1:numel(args));
        cost = optOut(end);
    end
end

dir_exists = exists_data(['cache/',name]);
if ~dir_exists
    mkdir(['cache/', name]);
end
save(['cache/', name, '/data.mat'], 'result_raw', 'cost');

for i = 1:5
    result(i).StartTime = result_raw( (i-1)*5 + 1 );
    result(i).IntervalTime = result_raw( (i-1)*5 + 2 );
    result(i).StartPower = result_raw( (i-1)*5 + 3 );
    result(i).DecayPower = result_raw( (i-1)*5 + 4 );
    result(i).Number = result_raw( (i-1)*5 + 5 );
end
    
if isfield(synthTask, 'plotProgress') && synthTask.plotProgress ~= 0
    [fit, y1, y2, x] = CostStraightCompare( X );
    semilogy(x, y1, x, y2);
    title([' Fitness: ' num2str(f)]);
end
end
