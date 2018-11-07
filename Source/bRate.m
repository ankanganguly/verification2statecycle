%Calculates the reference rate for the contact process
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
function [r,e] = bRate(X,lambda)

end