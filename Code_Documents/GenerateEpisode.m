function [States , Actions , Rewards] = GenerateEpisode(Plane , ... 
    AllStates ,AllActions ,Policy ,initialStateActionPair , Goal , ...
    epsilon , display , qPrediction)

    FinalTimeStep = 1e6 ; 
    States = zeros(FinalTimeStep , 2);
    Actions = zeros(FinalTimeStep , 1);
    Rewards = zeros(FinalTimeStep , 1);

    isFinalState = 0 ; 
    t = 1 ; 

    States(t , :) = initialStateActionPair(1 , [1 2]) ; 

    while 1

        if display
            Plane2 = Plane ; %% 1: free   0:barrier
            Plane2(States(t , 1) , States(t , 2)) = 3 ;
            Plane2(Goal(1) , Goal(2)+1) = 2 ;
            imagesc(Plane2) ;
            title(['Time Step ('  num2str(t) ')'] , 'fontsize' , 20);
            pause(0.1) ;
        end

         indexOfState = find(ismember(AllStates , States(t , :) , 'row')) ;
         
         if rand > epsilon %% 0.9
             At = Policy(indexOfState) ; %#ok
         else
             At = randi(size(AllActions , 1));
         end        
         
         if qPrediction == 1 && t == 1
             Actions(t , :) = initialStateActionPair(1 , [3 4]);
         else
             Actions(t , :) = At;
         end
         [States(t+1 , :) , Rewards(t+1)] = Environment(AllStates , States(t , :) , Actions(t , :) , Goal) ;

         if ismember(States(t+1 , :) , Goal , 'row') 
            isFinalState = 1 ; 
         end


        if isFinalState == 1

            if display
                Plane2 = Plane ; %% 1: free   0:barrier
                Plane2(States(t+1 , 1) , States(t+1 , 2)+1) = 3 ;
                Plane2(Goal(1) , Goal(2)+1) = 2 ;
                imagesc(Plane2) ;
                 title(['Time Step ('  num2str(t) ')'] , 'fontsize' , 20);
                pause(0.1) ;
            end

           break ; 
        end 
        t = t + 1 ;
    end

    States = States(1:t+1 , :) ; 
    Actions = Actions(1:t+1 , :) ; 
    Rewards = Rewards(1:t+1 , :) ; 

end