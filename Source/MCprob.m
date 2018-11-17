%Monte Carlo estimate of the relative probability of a path
%Inputs: 
%   cX: cell containing four objects (X on nodes 1,2)
%        ct: time at end of recorded process
%        cinit: initial value of process
%        cjumps: 3xjump array. 1: jumptimes 2: jumpvertices 3:jump values
%        cCurrVal: value of process at time t
%   samples: number of MC samples I'm taking
%   lambda: infection rate
%   nodes: number of nodes in full process we are conditioning over
%   initCond: Initial condition of full process
%Outputs:
%   pdense: probability density of path
%   relstdev: sample standard deviation/pdense. Hopefully this will be small

%Compute density that X follows cX on nodes 1 and 2

function [pdense,relstdev] = MCprob(cX,samples,lambda,nodes, ratebd,initCond)   
    %Initialize samples
    sampleSet = zeros(samples,1);
    
    for i = 1:samples
        %Run X in reference
        X = runProcess(nodes - 2, initCond, @bRate,ratebd,cX{1},{lambda,cX});

        %Get whole X
        X{2} = [cX{2};X{2}];
        jumps = X{3};
        if ~isempty(jumps)
            jumps(2,:) = 2+ jumps(2,:);
        end
        jumps = [cX{3},jumps];
        if ~isempty(jumps)
            jumps = (sortrows(jumps',1))';
        end
        X{3} = jumps;
        X{4} = [cX{4};X{4}];
        
        %DEBUG
        if i == 1
            display(i);
        end
        
        %Calculate density of X
        sampleSet(i) = exp(density(X,lambda));
        
%         %DEBUG
%         display('Denom')
%         display(i)
    end
    
    %Compute log of mean
    pdense = mean(sampleSet,1);
    stdev = std(sampleSet,1)/sqrt(samples);
    relstdev = stdev/pdense;        
end
