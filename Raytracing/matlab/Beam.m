classdef Beam
   	properties
        direction	= [0, 0]
        start       = [0, 0]
        amplitude   = 0
        distance    = 0
        point       = [0, 0]
        idx         = 0
   	end 
   	methods

      	function self = Beam(direction, start, amplitude, travel)
      		if (nargin == 1) && strcmp(class(wall), 'Segment')
            % Copy
                self.direction = direction.direction;
                self.start = direction.start;
                self.amplitude = direction.amplitude;
                self.distance = direction.distance;
                self.point = direction.point;

            elseif nargin == 1                    
      		% If only one arg specified set it as direction and amplitude starting from (0,0)
      			self.direction = direction;
      			self.start = [0,0];
                self.amplitude = 0;
                self.distance = 0;
                self.point = [0,0];
                self.Normalize();

      		elseif nargin == 2
      		% If 2 args.
                self.direction = direction;
                self.start = start;
                self.amplitude = 0;
                self.distance = 0;
                self.point = start;
                self.Normalize();

            elseif nargin == 3
                self.direction = direction;
                self.start = start;
                self.point = start;
                self.amplitude = amplitude;
                self.distance = 0;
                self.Normalize();

            elseif nargin == 4
                self.direction = direction;
                self.start = start;
                self.amplitude = amplitude;
                self.distance = travel;
                self.point = start;
                self.Normalize();

      		else
      			display ('Error. Not supported syntax');
            end
        end
        
        function self = Normalize(self)
            len = norm(self.direction);
            if len ~= 0
                self.direction = self.direction ./ len;
            end
        end

        function self = AddTravelDistance(self, distance)
            self.distance = self.distance + distance;
        end

        function self = AddIntersectionPoint(self, point, idx)
            len1 = norm(self.point - self.start);
            len2 = norm(self.point - point);
            
            if (len1 == 0) || (len2 < len1)
                self.point = point;
                self.idx = idx;
            end
        end

        function self = SumUpDistance(self)
            len = norm(self.point - self.start);
            self.AddTravelDistance(len);
        end

   	end
end

