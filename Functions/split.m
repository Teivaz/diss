function [ x1__ts x2__ts ] = split( y1_ts, y2_ts, F )
    %- –азделение пространственных каналов
    % Requires:
    %	y1_ts, y2_ts, F
    % Result: 
    %	x1__ts, x2__ts
    %y1_ts.Data(isnan(y1_ts.Data))=0;
%     y1_re_nans = isnan(real(y1_ts.Data));
%     y2_re_nans = isnan(real(y2_ts.Data));
%     y1_ts.Data(y1_re_nans)=0+imag(y1_ts.Data(y1_re_nans));
%     y2_ts.Data(y2_re_nans)=0+imag(y2_ts.Data(y2_re_nans));
    x1__ts = y1_ts;
    x2__ts = y2_ts;
    x1__ts.Name = 'Processed output 1';
    x2__ts.Name = 'Processed output 2';
    y1_ts.Data(isnan(y1_ts.Data)) = 0;
    y2_ts.Data(isnan(y2_ts.Data)) = 0;
    foo1 = filter(y1_ts, F(1).Data, 1);
    foo2 = filter(y2_ts, F(2).Data, 1);
    x1__ts.Data = foo1.Data + foo2.Data;
    foo1 = filter(y1_ts, F(3).Data, 1);
    foo2 = filter(y2_ts, F(4).Data, 1);
    x2__ts.Data = foo1.Data + foo2.Data;
end

