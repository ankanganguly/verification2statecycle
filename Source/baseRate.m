%Outputs unit rate for MCMC
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time
%    lambda: infection rate
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.

function r = baseRate(X,lambda)
    init = X{2};
    r = ones(size(init));
end