%Calculates standard rate for contact process
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time
%    v: node at which the rate is being evaluated
%    lambda: infection rate
%Outputs:
%    r: rate of process X at node v.

function r = rate(X,v,lambda)
    %Unpack X
    %t = X{1};
    init = X{2};
    %jumpTimes = X{3};
    jumpNodes = X{4};
    
    %Extract number of nodes
    nodes = size(init,1);
    
    %Extract current state of X
    currVal = current(init, jumpNodes);
    
    %rate of process depends on node
    if v == 1
        if currVal(1) == 0
            r = lambda/2*(currVal(nodes) + currVal(2));
        else
            r = 1;
        end
    elseif v == nodes
        if currVal(nodes) == 0
            r = lambda/2*(currVal(1) + currVal(nodes-1));
        else
            r = 1;
        end
    else
        if currVal(v) == 0
            r = lambda/2*(currVal(v-1) + currVal(v+1));
        else
            r = 1;
        end
    end
end