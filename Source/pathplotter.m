function Xpaths = pathplotter()
    Xs = cell(5);
    Xs{2} = 5;
    Xs{3} = [];
    Xs{4} = [];
    Xs{5} = [];
    
    for i = 1:1000
        X = runProcess(1000,0.5,@rate,1.1,5,1.1);
        Xs{1} = i;
        Xs{3} = [Xs{3};2;X{2}];
        Xs{4} = [Xs{4},zeros(3,1),X{3}];
        Xs{5} = [Xs{5};2;X{4}];
        
        if mod(i,50)==1
            display(i)
        end
    end
    
    x = linspace(0,5);
    s = max(size(x));
    
    Xpaths = zeros(1000,100);
    
    inits = Xs{3};
    initones = inits(mod(1:1001000,1001) == 2);
    
    jumps = [Xs{4},zeros(3,1)];
    jumps = jumps(:,jumps(2,:) < 2);
    
    for sym = 1:1000
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