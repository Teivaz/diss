function [name] = create_name(name, walls, transmitter, receiever)
	% check dirs
	checksum = 0;
	for wall = walls
		checksum = (checksum + wall.a(1) * 1e1);
		checksum = (checksum + wall.a(2) * 1e2);
		checksum = (checksum + wall.b(1) * 1e3);
		checksum = (checksum + wall.b(2) * 1e4);
	end
	checksum = (checksum + transmitter(1) * 1e5);
	checksum = (checksum + transmitter(2) * 1e6);
	checksum = (checksum + receiever(1) * 1e7);
	checksum = (checksum + receiever(2) * 1e8);
	
	name = [name, '_', num2str(checksum)];
end
