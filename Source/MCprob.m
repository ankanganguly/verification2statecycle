%Monte Carlo estimate of the relative probability of a path
%Inputs: 
%   cX: cell containing five objects
%       t: time at end of recorded process
%       nodeSet: number of nodes in condition (assumed adjacent)
%       init: initial value of process
%       jumpTimes: times of jumps of process
%       jumpNodes: Nodes which jump at a given time
%   samples: number of MC samples I'm taking
%   lambda: infection rate
%   nodes: number of nodes in full process we are conditioning over
%   initCond: Initial condition of full process
%Outputs:
%pdense: probability density of path
%relstdev: sample standard deviation/pdense. Hopefully this will be small

function [pdense,relstdev] = MCprob(cX,samples,lambda,nodes, initCond)
    %Unpack cX
    t = cX{1};
    cnodes = cX{2};
    cinit = cX{3};
    cjumpTimes = cX{4};
    cjumpNodes = cX{5};
    
    %Initialize samples
    sampleSet = zeros(samples,1);
    
    for i = 1:samples
        %Run X in reference
        Xc = runProcess(nodes - cnodes, initCond, @baseRate,nodes - cnodes,t,lambda);
        
        %Get whole X
        init = [cinit;Xc{2}];
        jumps = [cjumpTimes,cjumpNodes;Xc{3},Xc{4}];
        
        %sort jumps so that time is chronological
        jumps = sortrows(jumps);
        jumpTimes = jumps(:,1);
        jumpNodes = jumps(:,2);
        
        %reassemble X
        X = {t,init,jumpTimes,jumpNodes};
        
        %Calculate density of X
        sampleSet(i) = density(X,lambda);
    end
    
    pdense = sum(sampleSet)/samples;
    stdev = std(sampleSet);
    relstdev = stdev/pdense;        
end