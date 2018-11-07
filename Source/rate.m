%Calculates standard rate for contact process
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumps: 3xjump array. 1: jumptimes 2: jumpvertices 3:jump values
%        currVal: value of process at time t
%    lambda: infection rate
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.
%    e: 1

function [r,e] = rate(X,lambda)
    %Start with current value
    currVal = X{4};
    
    %Set e for debugging purposes
    e = 1;
    
    %Rate calculated using vector processes
    %at 0, rate is lambda/2*sum of neighbors
    r = lambda/2*(1-currVal).*(circshift(currVal,1,1) + circshift(currVal,-1,1));
    %r now sets 1 to 0. At 1 we actually want 1.
    r = r + (currVal == 1);
end