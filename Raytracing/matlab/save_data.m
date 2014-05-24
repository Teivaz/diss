function [] = save_data( name, beams, walls, transmitter, receiever )

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

	all_dirs = [];
	all_files = ls();
	for file = all_files'
		if isdir(file)
			all_dirs = [all_dirs; file'];
		end
	end

	dir_exists = 0;
	for dir = all_dirs'		
		if strcmpi(strtrim(dir'), name)
			dir_exists = 1;
			break;
		end
	end

	if ~dir_exists
		mkdir(name);
    end

	save([name, '/data.mat'], 'beams', 'walls', 'transmitter', 'receiever');

	h = figure;
	set(h,'visible','off');
	hold off;
	scatter(transmitter(1), transmitter(2));
	hold on;
	scatter(receiever(1), receiever(2));
	for wall = walls
		line([wall.a(1), wall.b(1)], [wall.a(2), wall.b(2)], 'LineWidth', 2);
	end
	hold off;
	saveas(h, [name, '/preview.jpg'], 'jpg');
    
end
