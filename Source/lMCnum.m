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

function [pdense,relstdev] = lMCnum(cX,samples,lambda,nodes, ratebd,initCond)   
    %Initialize samples
    sampleSet = zeros(samples,1);
    
    parfor i = 1:samples
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
        
        %Calculate density of X
        d = density(X,lambda);
        
        %Compute the rate
        r = sRate(X{4},lambda);
        r = r(2);
        
        %input the sample
        sampleSet(i) = d + log(r);
        
%         %DEBUG
%         display('Num')
%         display(i)
    end
    
    %Compute log of mean
    pdense = sampleSet(1);
    for i = 2:samples
        pdense = ladd(pdense,sampleSet(i));
    end
    pdense = pdense - log(samples);
    
    s = 2*labsdiff(sampleSet(1),pdense);
    for i = 2:samples
        s = ladd(s,2*labsdiff(sampleSet(i),pdense));
    end
    
    stdev = (s - log(samples - 1) - log(samples))/2;
    relstdev = exp(stdev-pdense);        
end

%Calculate the log of the sum of numbers given their logs
%Inputs:
%   a: log of first expression in sum
%   b: log of second expression in sum
%Outputs
%   s: log of sum
function s = ladd(a,b)
    c = min(a,b);
    d = max(a,b);
    if d == -Inf
        s = -Inf;
    else
        s = log1p(exp(c - d)) + d;
    end
end

function s = labsdiff(a,b)
    c = max(a,b);
    d = min(a,b);
    if d == -Inf
        s = c;
    else
        s = log(exp(c - d) - 1) + d;
    end
end