%Calculates rate of MC reference process parameterized by conditioned nodes
%Inputs:
%   X: (Path of MC process so far)
%        t: time at end of recorded process
%        init: initial value of process
%        jumpTimes: times of jumps of process
%        jumpNodes: Nodes which jump at a given time
%   lambda: [infection rate,ratebd,samples,nodes,initCond]
%Outputs:
%    r: vector. Component v of r is rate of process X at node v.
%    e: output error

%So this function should return the rate of a MC process. In the MC
%algorithm, I will run the ordinary runProcess function with this rate.
%Then in the MC algorithm I will substitute in the conditional nodes. This
%should run the full W process. I can simplify it later.
function [r,e] = rRate(X,lambda)
    %Extract X
    t = X{1};
    init = X{2};
    jumps = X{3};
    currVal = X{4};
    
    %Impatience
    display(t)
    
    %Unpack lambda
    lamb = lambda(1);
    ratebd = lambda(2);
    samples = lambda(3);
    nodes = lambda(4);
    initCond = lambda(5);
    
    %initialize r
    r = zeros(3,1);
    
    %v=2
    rtwo = sRate(currVal,lamb);
    r(2) = rtwo(2);
    
    %v=1
    %generate cX
    cX= cell(4);
    cX{1} = t;
    %condition on 1,2 = 2,3
    cX{2} = init(2:3);
    %Change jump nodes to 1,2
    if ~isempty(jumps)
        cJumps = jumps(:,and(jumps(2,:) > 1,jumps(2,:) <4));
        if ~isempty(cJumps)
            cJumps(2,:) = cJumps(2,:) - 1;
        end
    else
        cJumps = [];
    end
    cX{3} = cJumps;
    cX{4} = currVal(2:3);
    
    [rdone,edone] = MCprob(cX,samples,lamb,nodes,ratebd,initCond);
    [rnone,enone] = MCnum(cX,samples,lamb,nodes,ratebd,initCond);
    
    r(1) = exp(rnone-rdone);
    esone = (1 - 2*enone)/(1+2*edone);
    elone = (1 + 2*enone)/(1-2*edone);
    eone = max(1 - esone,elone - 1);
    
    %v=3
    %generate cX
    cX= cell(4);
    cX{1} = t;
    %condition on 1,2 = 2,1
    cX{2} = [init(2);init(1)];
    %change jump nodes to 1,2
    if ~isempty(jumps)
        cJumps = jumps(:,jumps(2,:) <3);
        if ~isempty(cJumps)
            cJumps(2,:) = 3 - cJumps(2,:);
        end
    else
        cJumps = [];
    end
    cX{3} = cJumps;
    cX{4} = [currVal(2);currVal(1)];
    
    [rdthree,edthree] = MCprob(cX,samples,lamb,nodes,ratebd,initCond);
    [rnthree,enthree] = MCnum(cX,samples,lamb,nodes,ratebd,initCond);
    
    r(3) = exp(rnthree-rdthree);
    esthree = (1 - 2*enthree)/(1+2*edthree);
    elthree = (1 + 2*enthree)/(1-2*edthree);
    ethree = max(1 - esthree,elthree - 1);
    
    %Compute error
    e = max(eone,ethree);
end