%Calculate the density of a contact process path wrt reference path
%Inputs:
%   X: cell containing four objects
%       t: time at end of recorded process
%       init: initial value of process
%       jumpTimes: times of jumps of process
%       jumpNodes: Nodes which jump at a given time
%   lambda: infection rate
%Outputs:
%   d: the radon-nikodym derivative

function d = density(X,lambda)
    %Initialize
    t = X{1};
    init = X{2};
    jumpTimes = X{3};
    jumpNodes = X{4};
    
    %Keep track of the number of nodes
    nodes = size(init,1);
    
    %Current state
    currState = init;
    
    %Compute everything directly if there are no jumps
    if size(jumpTimes,1) == 0
        d = exp(-(sum(sRate(init,lambda),1)-nodes)*t);
        return
    end
    
    %product of density at each jump
    logProdStuff = zeros(size(jumpTimes,1),1);
    
    %Short hack to make intStuff work.
    jumpTimes = [jumpTimes;t];
    
    %integrate over partition generated by jumps
    intStuff = zeros(size(jumpTimes,1),1);
    
    %Do first integral manually
    intStuff(1) = jumpTimes(1)*(sum(sRate(init,lambda),1)-nodes);
    
    %Keep track of X state
    
    %Iterate over jumpNodes since it is the same size as original jumpTimes
    for i = 1:size(jumpNodes,1)
        %start by computing current state
        nv = jumpNodes(i);
        currState(nv) = mod(currState(nv) + 1,2);
    end
end