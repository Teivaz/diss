TIME;
POWER;

Ts = 6.2500e-011;
dt = 1.1870;
NewTime = (1:801)*Ts;
NewAmpl = zeros(size(NewTime));

for j = 1:numel(TIME)
    currTime = (TIME(j)+dt)*1e-9;
    minDist = 1;
    minPos = 1;
    for i = 1:numel(NewTime)
        if minDist > abs(NewTime(i) - currTime)
            minDist = abs(NewTime(i) - currTime);
            minPos = i;
        end
    end
    NewAmpl(minPos) = POWER(j);
end
plot(NewTime, NewAmpl)
