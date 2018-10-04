%Calculates mean field rate for contact process
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time
%    lambda: infection rate
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.

function r = mRate(X,lambda)
    
    %initialize
    t = X{1};
    currVal = current(X{2},X{4});
    
    %Directly calculated elsewhere and hardcoded here.
    if currVal == 0
        if lambda ~= 1
            r = ((tanh((t + (2*atanh(lambda/(lambda - 1) - 1))/(lambda - 1))*(lambda/2 - 1/2)) + 1)*(lambda - 1))/(2*lambda);
            r = real(r);
        else
            r = 1/(t+2);
        end
    else
        r = 1;
    end
end