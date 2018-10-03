%Calculates standard rate for contact process
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time
%    lambda: infection rate
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.

function r = rate(X,lambda)
    %Unpack X
    %t = X{1};
    init = X{2};
    %jumpTimes = X{3};
    jumpNodes = X{4};
    
    %Extract number of nodes
    nodes = size(init,1);
    
    %Extract current state of X
    currVal = current(init, jumpNodes);
    
    %Rate calculated using vector processes
    %at 0, rate is lambda/2*sum of neighbors
    r = lambda/2*(1-currVal).*(circshift(currVal,1,1) + circshift(currVal,-1,1));
    %r now sets 1 to 0. At 1 we actually want 1.
    r = r + (currVal == 1);
end