function [X,e] = runatime()
    tic;
    [X,e] = runProcess(3,0.5,@rRate,1.1,5,[1.1,1.1,1000,15,0.5]);
    toc;
end