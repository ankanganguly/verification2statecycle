%Plots the mean of X at vertex 1 over time
%Inputs:
%   nodes: number of nodes
%   initCond: initial conditions are iid Bernoulli. Gives probability of 1.
%   rateFnct: Handle to rate function.
%   ratebd: upper bound on rate to speed up process (nodes*max(rateFnct))
%   time: Amount of time to run simulation.
%   lambda: input parameter
%   samples: number of samples
%   step: number of steps
%Outputs:
%   tIn: inputs for plot times
%   mIn: inputs for plot 

function [tIn,mIn] = plotTyp(nodes, initCond, rateFnct, ratebd,time,lambda,samples,step)
    %Fix jump times and values
    times = transpose(0:time/step:time);
    vals = zeros(size(times));
    totvals = zeros(size(times));
    
    for s = 1:samples
        %display
        if mod(s,30) == 1
            disp('starting sample number: ')
            disp(s)
        end
        
        %Get sample
        X = runProcess(nodes,initCond,rateFnct,ratebd,time,lambda);
        
        %Extract sample info
        init = X{2};
        jumpTimes = X{3};
        jumpNodes = X{4};
        
        %Only keep track of jump times on first node
        jumpTimes = jumpTimes(jumpNodes == 1);
        
        %Initialize count of jumps covered
        jumpCount = 1;
        
        %Initialize vals time 0 sample to init at vertex 1
        vals(1) = init(1);        
        
        %Update vals starting at second time step
        for t = 2:size(times,1)
            %Check if there was a jump since last interval
            if jumpCount <= size(jumpTimes,1)
                %Keep track of number of jumps in interval
                jumps = 0;
                %Iterate until all jumps complete
                while jumpTimes(jumpCount) < times(t)
                    %Increment number of jumps
                    jumps = jumps + 1;
                    
                    %Increment jump count
                    jumpCount = jumpCount + 1;
                    
                    %Prevent overflow
                    if jumpCount > size(jumpTimes,1)
                        break;
                    end
                end
                
                %update vals
                vals(t) = mod(vals(t-1) + jumps,2);
            else
                vals(t) = vals(t-1);
            end
        end
        
        %Update totvals
        totvals = totvals + vals;
        
        %Reset vals
        vals = zeros(size(times));
    end
        
    avgvals = totvals/samples;
    tIn = times;
    mIn = avgvals;
    plot(tIn,mIn);
end