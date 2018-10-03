%This takes process identifiers as input and outputs the current value of
%the process.
%Inputs:
%    init: vertical vector. init(i) is the initial state of the ith node.
%    jumpNodes: vertical vector listing all nodes in chronological order.
%Output:
%    currVal: vertical vector. currVal(i) is the current state of node i.

function currVal = current(init, jumpNodes)
    %Start at initial values
    currVal = init;
    
    %For each jump, update the value at the jump node.
    for i = 1:size(jumpNodes,1)
        currVal(jumpNodes(i)) = currVal(jumpNodes(i)) + 1;
    end
    
    %Reduce back to 2 states.
    currVal = mod(currVal,2);
end