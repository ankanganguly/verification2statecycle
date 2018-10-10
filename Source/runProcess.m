%Runs the process given a certain rate handle
%Inputs:
%   nodes: number of nodes
%   initCond: initial conditions are iid Bernoulli. Gives probability of 1.
%   rateFnct: Handle to rate function.
%   ratebd: upper bound on rate to speed up process (nodes*max(rateFnct))
%   time: Amount of time to run simulation.
%   lambda: input parameter(s)
%Outputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time

function X = runProcess(nodes, initCond, rateFnct, ratebd, time, lambda)
    %This constant pops up a lot
    evntbd = ceil(3*ratebd*time);
    
    %Initialize elements of X
    t = 0;
    init = binornd(1,initCond,nodes,1);
    jumpTimes = zeros(evntbd,1);
    jumpNodes = jumpTimes;
    X = {0,init,[],[]};
    
    %Initialize randomness
    randJumps = exprnd(1/ratebd,evntbd,1);      %Poisson jumps
    
    %Counters act as pointers to first open entry in corresponding array
    rjumpCounter = 1;                           %Number of generator jumps
    jumpCounter = 1;                            %Number of actual jumps
    
    while t < time;
        %Prevent overflow of random generator (happens with low prob)
        if rjumpCounter > size(randJumps,1)
            randJumps = [randJumps;exprnd(1/ratebd,evntbd,1)];
        end
        
        %Prevent overflow of jump tracker (happens with low prob)
        if jumpCounter > size(jumpTimes,1)
            jumpTimes = [jumpTimes;zeros(evntbd,1)];
            jumpNodes = [jumpNodes;zeros(evntbd,1)];
        end
        
        %Compute current time. Note: last iteration will finish with t>time
        t = t + randJumps(rjumpCounter);
        X{1} = t;
        
        %increment random jump counter
        rjumpCounter = rjumpCounter + 1;
        
        %Compute jump rate
        r = rateFnct(X,lambda);
        
        %Derive multinomial probability
        p = [r/ratebd;1 - sum(r,1)/ratebd];
        
        %Sample jump node
        v = find(mnrnd(1,p),1);
        
        if v == nodes + 1
            %Do nothing
        else
            %update jumps and jump counter
            jumpTimes(jumpCounter) = t;
            jumpNodes(jumpCounter) = v;
            jumpCounter = jumpCounter + 1;
            
            %Update X
            X{3} = jumpTimes(1:jumpCounter-1);
            X{4} = jumpNodes(1:jumpCounter-1);
        end
    end
    
    %Update jump nodes to only reflect jumps in relevant time period
    jumpNodes = jumpNodes(and(jumpTimes < time,jumpTimes > 0));
    
    %Update jump times to only reflect jumps in relevant time period
    jumpTimes = jumpTimes(and(jumpTimes < time,jumpTimes > 0));
    
    X = {time,init,jumpTimes,jumpNodes};       
end