function [beams, walls, transmitter, receiever] = load_data(name)
	data = load([name, '/data.mat']);
	beams = data.beams;
	walls = data.walls;
	transmitter = data.transmitter;
	receiever = data.receiever;
end