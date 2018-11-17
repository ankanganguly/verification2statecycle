function Xs = longTermXs(time,samples,nodes,lambda)
    Xs = cell(5);
    Xs{2} = time;
    Xs{3} = [];
    Xs{4} = [];
    Xs{5} = [];
    
    for i = 1:samples
        X = runProcess(nodes,1,@fbrate,lambda,time,lambda);
        Xs{1} = i;
        Xs{3} = [Xs{3};2;X{2}];
        Xs{4} = [Xs{4},zeros(3,1),X{3}];
        Xs{5} = [Xs{5};2;X{4}];
        
        if mod(i,50)==1
            display(i)
        end
    end
end