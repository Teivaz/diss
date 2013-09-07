function [ X, Y ] = find_extrems( Xinput, Yinput )
    %- Finds extrems
extrems = diff(Yinput);
maxes = zeros(size(extrems));
prev = extrems(1);
for i = 1:numel(extrems)
    maxes(i) = 0;
    if (sign(prev) ~= sign(extrems(i)))
        maxes(i) = 1;        
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

