function [ X, Y ] = find_extrems( Xinput, Yinput, mode )
    %- mode 'all', 'min', 'max'
extrems = diff(Yinput);
maxes = zeros(size(extrems));
prev = extrems(1);
mode_all = 1;
mode_min = 0;
mode_max = 0;

if exist('mode', 'var')
   if strcmp(mode, 'all')
       mode_all = 1;
       mode_min = 0;
       mode_max = 0;
   elseif strcmp(mode, 'max')
       mode_all = 0;
       mode_min = 0;
       mode_max = 1;
   elseif strcmp(mode, 'min')
       mode_all = 0;
       mode_min = 1;
       mode_max = 0;
   end
end


for i = 1:numel(extrems)
    maxes(i) = 0;
    if (sign(prev) ~= sign(extrems(i)))
        if mode_all
            maxes(i) = 1;
        elseif mode_max && (prev > 0)
            maxes(i) = 1;
        elseif mode_min && (prev < 0)
            maxes(i) = 1;
        end
    end
    prev = extrems(i);
end

o = 1;
for i = 1:numel(maxes)
    if (maxes(i) == 1)
       X(o) = Xinput(i);
       Y(o) = Yinput(i);
       o = o + 1;
    end
end


end

