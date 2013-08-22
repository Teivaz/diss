
x1 = 2.688;
x2 = 3.875;
dx = x2 - x1;
for a = 1:100

    POS = POS1;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS2;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS3;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS4;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS5;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS4;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS3;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
    
    POS = POS2;
    ex3_ampl = db2mag((POS(:,2)));
    maxval = max(ex3_ampl);
    ex1_time = POS(:,1)*1e9 - dx;
    ex3_ampl = ex3_ampl./maxval;
    plot(ex1_time, ex3_ampl);
    drawnow;
    xlim([0, 40]);
    set(gca, 'XTick', 0:40);
    set(gca, 'YScale', 'log');
    pause(0.2);
end