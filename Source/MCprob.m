%Monte Carlo estimate of the relative probability of a path
%Inputs: 
%   cX: cell containing five objects (X on nodes 1,2)
%       t: time at end of recorded process
%       init: initial value of process
%       jumpTimes: times of jumps of process
%       jumpNodes: Nodes which jump at a given time
%   samples: number of MC samples I'm taking
%   lambda: infection rate
%   nodes: number of nodes in full process we are conditioning over
%   initCond: Initial condition of full process
%Outputs:
%   pdense: probability density of path
%   relstdev: sample standard deviation/pdense. Hopefully this will be small

%Compute density that X follows cX on nodes 1 and 2

function [pdense,relstdev] = MCprob(cX,samples,lambda,nodes, initCond)
    %Unpack cX
    ct = cX{1};
    cinit = cX{2};
    cjumpTimes = cX{3};
    cjumpNodes = cX{4};
    
    %Initialize samples
    sampleSet = zeros(samples,1);
    
    for i = 1:samples
        %Run X in reference
        Xc = runProcess(nodes - cnumNodes, initCond, @baseRate,nodes - cnumNodes,ct,lambda);
        
        %Get whole X
        init = [cinit;Xc{2}];
        jumps = [cjumpTimes,cjumpNodes;Xc{3},Xc{4}];
        
        %sort jumps so that time is chronological
        jumps = sortrows(jumps);
        jumpTimes = jumps(:,1);
        jumpNodes = jumps(:,2);
        
        %reassemble X
        X = {ct,init,jumpTimes,jumpNodes};
        
        %Calculate density of X
        sampleSet(i) = density(X,lambda);
    end
    
    pdense = sum(sampleSet)/samples;
    stdev = std(sampleSet);
    relstdev = stdev/pdense;        
end