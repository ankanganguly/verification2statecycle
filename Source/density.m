%Calculate the density of a contact process path wrt reference path
%Inputs:
%    X: cell containing four objects
%        t: time at end of recorded process
%        init: initial value of process
%        jumps: 3xjump array. 1: jumptimes 2: jumpvertices 3:jump values
%        currVal: value of process at time t
%    lambda: infection rate
%Outputs:
%    d: the log radon-nikodym derivative

%Equation. d1 = sum_{jumps in 1,2} log sRate(X(t-),v) - log bRate(X(t-),v)
%d2 = -sum_{jumps}(time from last jump)(sRate(X(prev),v) - bRate(X(prev),v))
%d = d1 + d2

%Assumption: Condition of base process is the same as vertex history at
%vertices 1 and 2.

%Simplification: only need to care about vertices 1,2,3 and end, because
%the jump rate at every vertex except 1 and 2 is the same.

function d = density(X,lambda)
    %Unpack X
    T = X{1};
    init = X{2};
    jumps = X{3};
    
    %number of nodes
    n = size(init,1);
    
    %Thin to only include what we need
    init = init([1,2,3,end]);
    jumps = jumps(:,or(jumps(2,:) < 4, jumps(2,:) == n));

    %Set the state trackers
    currState = init; 
    
    %Set rate trackers
    curRate1 = sRate(currState, lambda);
    curRate2 = bsRate(currState,lambda);%Note: bsRate(3:4) is wrong now
        
    %Set counters
    events = size(jumps,2);
    t = 0;
    d1 = 0;
    d2 = 0;
    
    %compute d1 and d2
    for i = 1:events
        %add to d1
        if jumps(2,i) < 3
            %Degenerate case
            %Check for absolute continuity or 0 probability
            if curRate1(jumps(2,i))==0
                d = -Inf(1);
                return;
            elseif curRate2(jumps(2,i))==0
                error('Absolute continuity failure.')
            end
            
            %normal case
            d1 = d1 + log(curRate1(jumps(2,i))) - log(curRate2(jumps(2,i)));
        end
        
        %Add to d2. ti interval from previous jump. curRates are rates from
        %previous jump.
        ti = jumps(1,i) - t;
        d2 = d2 + ti*(curRate2 - curRate1);
        
        %update everything
        t = jumps(1,i);
        if jumps(2,i) == n
            currState(end) = jumps(3,i);
        else
            currState(jumps(2,i)) = jumps(3,i);
        end
        curRate1 = sRate(currState, lambda);
        curRate2 = bsRate(currState, lambda);    
    end
    
    %d2 needs to update its integral after the last jump
    ti = T - t;
    d2 = d2 + ti*(curRate2 - curRate1);
    
    %get rid of the vector d2
    d2 = d2(1) + d2(2);
    
    %Get d
    d = d1 + d2;
end