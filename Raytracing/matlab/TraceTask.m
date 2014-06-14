classdef TraceTask
	properties
		% Degrees
		sweepStep1Pass = 10;
		sweepStep2Pass = 10;

		% Array of segments
		obstacles = [Segment([0,0],[0,0],[0,0])];

		transmitterPosition = [0, 0];
		receiverPosition = [0, 0];

		showGraphs = 0;
		showProgressGraphs = 0;
	end
end
