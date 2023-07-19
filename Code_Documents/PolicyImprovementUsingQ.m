function Policy = PolicyImprovementUsingQ(Q , nActions)

    nStates = size(Q , 1)/nActions ;
    Policy = zeros(nStates , 1);
    
    for s = 2:nStates
        QQ = Q(1+nActions*(s-1):nActions*s) ;
        idx = find(QQ == max(QQ)) ; %[ 1 2 8 8 1]
        Policy(s) = idx(randi(numel(idx)));
    end

end