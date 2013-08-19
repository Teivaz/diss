function stop = history(x,optimValues,state)
stop = false;
    switch state
        case 'init'
            display('Start');
        case 'iter'
            display(['X(',num2str(1+optimValues.iteration),',:)=[',...
                num2str(x(1)),';',num2str(x(2)),';',num2str(x(3)),'];']);
        case 'done'
            display('done');
    end

end
