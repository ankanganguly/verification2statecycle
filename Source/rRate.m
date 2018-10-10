%Calculates rate of MC reference process parameterized by conditioned nodes
%Inputs:
%   X: (Path of MC process so far)
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time
%   lambda: {infection rate, cX}
%       cX: cell containing 4 objects (fixed path on 1,2)
%       	t: time at end of recorded process
%       	init: initial value of process
%           jumpTimes: times of jumps of process
%           jumpNodes: Nodes which jump at a given time
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.

%So this function should return the rate of a MC process. In the MC
%algorithm, I will run the ordinary runProcess function with this rate.
%Then in the MC algorithm I will substitute in the conditional nodes. This
%should run the full W process. I can simplify it later.
function r = rRate(X,lambda)
    %Extract lambda
    lamb = lambda{1};
    cX = lambda{2:5};
    
    %Extract X
    t = X{1};
    init = X{2};
    %jumpTimes = X{3};  Seems to be unused
    jumpNodes = X{4};
    
    %Extract cX
    ct = cX{1};
    cInit = cX{2};
    cJumpTimes = cX{3};
    cJumpNodes = cX{4};
    
    %Count number of conditional jumps
    cJumps1 = nnz(cJumpNodes == 1);
    cJumps2 = nnz(cJumpNodes == 2);
    
    %Make sure we have more to condition on and avoid divide by 0 errors
    if ct < t
        error('Overran conditioned process');
    elseif ct == 0
        error('ran rate at 0');
    elseif t == 0
        error('ran rate at 0');
    end
    
    %Change conditioned path to be consistent with t
    cX = {t,cInit, cJumpTimes(cJumpTimes <= t), cJumpNodes(cJumpTimes <=t)};
    
    %Get current states
    XCurr = current(init,jumpNodes);
    cXCurr = current(cX{2},cX{4});
    
    %Get hybrid process for endpoints
    cXXCurrHyb = [cXCurr;XCurr(3:end)];

    %Get rate of ordinary contact process
    r = rate(X,lamb);
    
    %Update rate of independent paths
    r(1) = cJumps1/ct;
    r(2) = cJumps2/ct;
    
    %Get rate of border processes
    rb = sRate(cXXCurrHyb,lamb);
    r(end) = rb(end);
    r(3) = rb(3);
end