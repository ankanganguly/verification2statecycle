%Calculates standard rate for contact process
%Inputs:
%   state: a vector indicating a state of the process X.
%   lambda: infection rate
%Outputs:
%   r: rate of process X_t- = state at node v.

function r = sRate(state,lambda)

    %Rate calculated using vector processes
    %at 0, rate is lambda/2*sum of neighbors
    r = lambda/2*(1-state).*(circshift(state,1,1) + circshift(state,-1,1));
    %r now sets 1 to 0. At 1 we actually want 1.
    r = r + (state == 1);
end