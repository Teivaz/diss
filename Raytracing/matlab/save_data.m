function [] = save_data( name, beams, walls, transmitter, receiever )
	dir_exists = exists_data(name);

	if ~dir_exists
		mkdir(['cache/', name]);
    end

	save(['cache/', name, '/data.mat'], 'beams', 'walls', 'transmitter', 'receiever');

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
	saveas(h, ['cache/', name, '/preview.jpg'], 'jpg');
    
end
