%Runs the process given a certain rate handle
%Inputs:
%   nodes: number of nodes
%   initCond: initial conditions are iid Bernoulli. Gives probability of 1.
%   rate: Handle to rate function.
%   ratebd: upper bound on rate to speed up process
%   time: Amount of time to run simulation.
%   lambda: input parameter
%Outputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time

function X = runProcess(nodes, initCond, rate, ratebd, time, lambda)
    %Initialize elements of X
    t = time;
    init = binornd(1,initCond,nodes,1);
    jumpTimes = zeros(3*ratebd*time,1);
    jumpNodes = jumpTimes;
end