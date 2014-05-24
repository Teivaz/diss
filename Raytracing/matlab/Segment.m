classdef Segment
	properties
		a = [0, 0];
		b = [0, 0];
		normal = [0, 0];
	end	
	methods
		function self = Segment(a, b, normal)
			self.a = a;
			self.b = b;
			self.normal = normal;
			self.Normalize();
		end

		function self = Normalize(self)
			len = norm(self.normal);
			if len ~= 0;
				self.normal = self.normal ./ len;
			end
		end

		function [point, intersects] = Intersect(self, beam)
			% t * beam.direction(1) = self.a(1) - beam.start(1) + lambda * (self.b(1) - self.a(1))
			% t * beam.direction(2) = self.a(2) - beam.start(2) + lambda * (self.b(2) - self.a(2))
			% =>
			% -(self.a(1) - beam.start(1)) = - t * beam.direction(1) + lambda * (self.b(1) - self.a(1));
			% -(self.a(2) - beam.start(2)) = - t * beam.direction(2) + lambda * (self.b(2) - self.a(2));

			B = [-(self.a(1) - beam.start(1)); -(self.a(2) - beam.start(2))];
			A = [[-beam.direction(1); -beam.direction(2)], [(self.b(1) - self.a(1)); (self.b(2) - self.a(2))]];
			[X, R] = linsolve(A, B);
			t = X(1);
            lambda = X(2);
			if (R ~= 0) &&... % Lines are not parallel
			   (lambda <= 1) && (lambda >= 0) &&... % point within segment bounds
			   (t >= 0) % Positive beam direction
				intersects = 1;
			else
				intersects = 0;
			end
			
			point = lambda * (self.b - self.a) + self.a;
		end

	end
end
