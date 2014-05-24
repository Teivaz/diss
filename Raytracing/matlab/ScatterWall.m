function out = ScatterWall( beam, wall, direction )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
	
	out = Beam(direction, beam.point);
	dotFall = dot(wall.normal, beam.direction);
	dotReflect = dot(wall.normal, direction);

	if sign(dotFall) == sign(dotReflect)
	% Opposite direction
		out.amplitude = 0;
		return;
	end

	reflect = -2 * dot(beam.direction, wall.normal)*wall.normal + beam.direction;
	out.amplitude = abs(dot(direction, reflect).^2) * beam.amplitude;
	out = out.AddTravelDistance(beam.distance);
	out = out.AddTravelDistance( norm(beam.start - beam.point) );
end

