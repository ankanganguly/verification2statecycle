%Calculates the reference rate for the contact process
%Assumes the value of X on vertices 1,2 matches the condition
%Inputs:
%    currVal: value of process at time t
%    lambda: infection rate
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.
%    e: 1
function [r,e] = bsRate(currVal,lambda)
    %Post error
    e = 1;
    
    %Get alternate states for averaging
    modcurrVal = currVal;
    modcurrVal(3) = 1 - currVal(3);
    modcurrVal(end) = 1 - currVal(end);
    
    %get average rates
    r1 = sRate(currVal,lambda);
    r2 = sRate(modcurrVal,lambda);
    
    r = r1;
    r(1:2) = mean([r1(1:2),r2(1:2)],2);
end