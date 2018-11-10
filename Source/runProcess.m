%Runs the process given a certain rate handle
%Inputs:
%   nodes: number of nodes
%   initCond: initial conditions are iid Bernoulli. Gives probability of 1.
%   rateFnct: Handle to rate function. Can include extra output (error)
%   ratebd: upper bound on rate to speed up process (max(rateFnct))
%   time: Amount of time to run simulation.
%   lambda: input parameter(s)
%Outputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumps: 3xjump array. 1: jumptimes 2: jumpvertices 3:jump values
%        currVal: value of process at time t
%    e: array of outputs of rateFnct. Must be a double.

function [X,e] = runProcess(nodes, initCond, rateFnct, ratebd, time, lambda)
    %Number of Poisson jumps in thinning process
    expevnts = nodes*ratebd*time;
    evntbd = poissrnd(expevnts);
    %Conditioned on the number of jumps, events are unif dist.
    PoissJumps = sort(time*rand(1,evntbd)); %time is horizontal
    
    %Initialize elements of X
    init = binornd(1,initCond,nodes,1);     %vertices are vertical
    jumps = zeros(3,evntbd);
    currVal = init;
    ti = 0;
    
    %Initialize X: Cells are horizontally arranged
    X = cell(1,4);
    X{1} = ti;
    X{2} = init;
    X{3} = zeros(0);
    X{4} = currVal;
    
    %Initialize e
    e = zeros(evntbd,2);
    
    %Initialize counters: counter indicates entry of interest
    jumpCounter = 1;                            %Number of actual jumps
    
    for t = 1:evntbd
        %Update time of X immediately
        ti = PoissJumps(t);
        X{1} = ti;
        
%         %DEBUG
%         display(rateFnct)
%         display(t)
        
        %Compute jump rate
        [r,eout] = rateFnct(X,lambda);
        
        %Update e
        e(t,1) = eout;
        e(t,2) = ti;
        
        %Derive multinomial probability
        p = [r/(nodes*ratebd);1 - sum(r,1)/(nodes*ratebd)];
        
        %Sample jump node
        v = find(mnrnd(1,p),1);
        
        if v == nodes + 1
            %Do nothing
        else
            %update jumps
            jumps(1,jumpCounter) = PoissJumps(t);
            jumps(2,jumpCounter) = v;
            jumps(3,jumpCounter) = 1 - currVal(v);
            
            %update X
            X{3} = jumps(:,1:jumpCounter);
            
            %Update current value
            currVal(v) = 1 - currVal(v);
            
            %update X
            X{4} = currVal;
            
            %Update jump counter
            jumpCounter = jumpCounter + 1;
        end
    end
    
    %After last jump, only time updates.
    X{1} = time;
end