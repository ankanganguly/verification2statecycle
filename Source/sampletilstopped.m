function sampletilstopped()

    %Setup
%    load('100MC15NContactrunfixed','Xs')
    
%     %Counter
    i = 0;
%      i = Xs{1};
%     
%     %storage variables
    Xs = cell(6);
    Xs{1} = 0;                              %number of samples
    Xs{2} = 5;                              %time
    Xs{3} = [];                             %Initial
    Xs{4} = [];                             %jumps
    Xs{5} = [];                             %current value
    Xs{6} = [];                             %error/jump rates
    while true
        %Increment i to reflect current number of iterations
        i = i+1
        
        %Sample
        [X,e] = runatime();
        
        %Update samples
        Xs{1} = i;
        Xs{3} = [Xs{3};2;X{2}];
        Xs{4} = [Xs{4},zeros(3,1),X{3}];
        Xs{5} = [Xs{5};2;X{4}];
        Xs{6} = [Xs{6};zeros(1,3);e];
        
        %Save samples
        save('100MC15NContactrunfixed','Xs')
        %clear;
    end
end