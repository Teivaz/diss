function [out, num] = Reflect(walls, currentWallNum, beam)
    num = 0;
	for i = 1:length(walls)
		if i == currentWallNum
			continue;
		end
        wall = walls(i);
		[point, intersects] = wall.Intersect(beam);
		if intersects
			beam = beam.AddIntersectionPoint(point, i);
			num = i;
        end
    end
    out = beam;
end
