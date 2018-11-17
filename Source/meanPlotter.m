function [x,Xpath] = meanPlotter(Xs)

x = linspace(0,Xs{2});
s = max(size(x));

samples = Xs{1};

Xpaths = zeros(samples,s);

inits = Xs{3};
%Start from here
meanInits = mean(inits,1);

jumps = [Xs{4},zeros(3,1)];

for sym = 1:samples
    for i = 1:s
        if i==1
            currX = initones(sym);
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