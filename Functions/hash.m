function [ ret ] = hash( args )
%HASH Summary of this function goes here
%   Detailed explanation goes here

ret = uint32(0);
for i = 1 : size(args, 2)
    wide_arg = typecast(args(i), 'uint16');
    
    for j = 1 : 4
        ret_ = uint32(ret + uint32(wide_arg(j)));
        ret_ = uint32(ret_ + bitshift(ret_, 10));
        ret_ = uint32(bitxor(ret_, bitshift(ret_, -6)));
        ret = ret_;
    end
end

ret = ret + bitshift(ret, 3);
ret = bitxor(ret, bitshift(ret, -11));
ret = ret + bitshift(ret, 15);

end

