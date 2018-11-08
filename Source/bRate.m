%Calculates the reference rate for the contact process
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumps: 3xjump array. 1: jumptimes 2: jumpvertices 3:jump values
%        currVal: value of process at time t
%    lambda: [infection rate;cxstate1;cxstate2]
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.
%    e: 1
function [r,e] = bRate(X,lambda)
    %Post error
    e = 1;
    
    %Get current value of X
    currVal = X{4};
    
    %Get lambda
    lamb = lambda(1);
    
    %Get current conditional value of x
    cxVal = lambda(2:3);
    
    %update it into our state calculations
    cxcurrVal = [cxVal;currVal(3:end)];
    
    %Get alternate states for averaging
    modcxcurrVal = cxcurrVal;
    modcxcurrVal(3) = 1 - cxcurrVal(3);
    modcxcurrVal(end) = 1 - cxcurrVal(end);
    
    %get average rates
    r1 = sRate(cxcurrVal,lamb);
    r2 = sRate(modcxcurrVal,lamb);
    
    r = r1;
    r(1:2) = mean([r1(1:2),r2(1:2)],2);
end