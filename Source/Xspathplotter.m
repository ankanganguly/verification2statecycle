%Inputs:
%   Xs: Cell with 6 entries
%       i: Number of samples
%       t: total time of each simulation
%       init: initial conditions buffered by 2 (extra 2 at start)
%       jumps: jump information buffered by (0;0;0) (extra buffer at start)
%       currVal: current values buffered by 2 (extra 2 at start)
%       errors: relative 95% CI radius, time of jumps, intensity buffered
%           by 0
%   nodes: Number of nodes in process
%Outputs:
%   Xpaths: paths of each sample at node 1 at linspace times


function [x,Xpaths] = Xspathplotter(Xs, nodes, node, time)
    x = linspace(0,time);
    s = max(size(x));
    
    samples = Xs{1};
    
    Xpaths = zeros(samples,s);
    
    inits = Xs{3};
    initones = inits(mod(1:(nodes + 1)*samples,nodes + 1) == 2);
    
    jumps = [Xs{4},zeros(3,1)];
    jumps = jumps(:,jumps(2,:) == node);
    
    for sym = 1:samples
        for i = 1:s
            if i==1
                Xpaths(sym,i) = initones(sym);
                jumps = jumps(:,2:end);
                continue
            end
            
            val = Xpaths(sym,i-1);
            while and(jumps(2,1) ~= 0, x(i) > jumps(1,1))
                if jumps(2,1) == 1
                    val = jumps(3,1);
                end
                jumps = jumps(:,2:end);
            end
            
            Xpaths(sym,i) = val;
        end
    end
end