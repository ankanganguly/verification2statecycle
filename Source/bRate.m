%Calculates the reference rate for the contact process
%Assumes X is modelled on vertices 3-n
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumps: 3xjump array. 1: jumptimes 2: jumpvertices 3:jump values
%        currVal: value of process at time t
%    lambda: {infection rate,cX}
%        cX: cell containing four objects
%            ct: time at end of conditional process
%            cInit: conditional initial condition
%            cJumps: same as jump but on conditioned nodes
%            cCurrVal: current conditional value
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.
%    e: 1
function [r,e] = bRate(X,lambda)
    %Extract lambda
    lamb = lambda{1};
    cX = lambda{2};
    
    %Make sure conditioned time is sufficiently large
    t = X{1};
    ct = cX{1};
    if t > ct
        error('time malfunction')
    end
    
    %Extract current state except for vertices 1,2
    currVal = X{4};
    %Buffer
    currVal = [0;0;currVal];
    
    %Get conditional current value
    %Extract
    cJumps = cX{3};
    cInit = cX{2};
    
    %Look at jumps before the current time. Only these matter
    cJ = cJumps(:,cJumps(1,:) <= t);
    
    %Find the last jump time at each conditioned node
    v1 = find(cJ(2,:) == 1,1,'last');
    v2 = find(cJ(2,:) == 2,1,'last');
    
    %If empty, use conditional initial condition, otherwise fill in last
    %jump value
    if isempty(v1)
        currVal(1) = cInit(1);
    else
        currVal(1) = cJ(3,v1);
    end
    if isempty(v2)
        currVal(2) = cInit(2);
    else
        currVal(2) = cJ(3,v2);
    end
    
    %Use bsRate
    [r,e] = bsRate(currVal,lamb);
end