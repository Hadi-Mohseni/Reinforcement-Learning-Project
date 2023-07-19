clc;
clear;
close all;

%% 
game_plane_size = 101; 
Plane = ones(1, game_plane_size); 
imagesc(Plane); 

%%
Goal = [1 0];
[R , C] = find(Plane == 1) ;
AllStates = [R' C'-1] ;
nStates = size(AllStates , 1) ;

% AllActions = [0.3  0.6  1.2  1.8 ;...
%               0.6  1.2  2.4  3.6 ;...
%               0.9  1.8  3.6  5.4 ;...
%               1.2  2.4  4.8  7.2 ;...
%               1.5  3.0  6.0  9.0 ;...
%               1.8  3.6  7.2  10.8;...
%               2.1  4.2  8.4  12.6;...
%               2.4  4.8  9.6  14.4;...
%               2.7  5.4  10.8 16.2;...
%               3.0  6.0  12.0 18.0];
AllActions = [1  11  21  31 ;...
    2  12  22  32 ;...
    3  13  23  33 ;...
    4  14  24  34 ;...
    5  15  25  35 ;...
    6  16  26  36;...
    7  17  27  37;...
    8  18  28  38;...
    9  19  29  39;...
    10 20  30  40];


nActions = size(AllActions , 1)*size(AllActions , 2) ;

AllStateActionPairs = zeros(nStates*nActions , 3);

for i = 1:nStates
    for j = 1:size(AllActions , 2)
        AllStateActionPairs(1+size(AllActions , 1)*(4*(i-1)+j-1):size(AllActions , 1)*(4*(i-1)+j) , :) = [repmat((AllStates(i , :)),size(AllActions , 1),1) , AllActions(1:size(AllActions , 1),j)];
    end
end
%%
nAllStateActionPairs = size(AllStateActionPairs , 1) ;

Counter = zeros(nAllStateActionPairs , 1);
Q = zeros(nAllStateActionPairs , 1);

gamma =0.99  ;
nEpisode = 10000;
epsilon = 0.15 ;

Policy = randi(nActions , nStates , 1);

alpha = 0.1 ;
%% 
for e = 1:nEpisode

    State = [1, 100];

    while 1
        indexOfState = find(ismember(AllStates, State, 'row'));

        % Choose an action based on the policy with epsilon-greedy exploration
        randomNum = rand;
        if randomNum < ((1 - epsilon) + (epsilon / nActions))
            At = Policy(indexOfState); % Exploitation: choose action from the policy
        else
            At = randi(nActions); % Exploration: choose a random action
        end

        [NewState, Reward] = Environment(AllStates, State, At, Goal);

        if ismember(NewState, Goal, 'row')
            break;
        end

        indexInPairs = find(ismember(AllStateActionPairs, [State, At], 'row'));
        indexOfNextStateInPairs = find(ismember(AllStateActionPairs(:, [1, 2]), NewState, 'row'));
        a_prime = Policy(NewState(2)+1);
        indexOfNextStateInPairs = indexOfNextStateInPairs(a_prime);
        
        Q(indexInPairs) = Q(indexInPairs) + alpha * (Reward + gamma * Q(indexOfNextStateInPairs) - Q(indexInPairs));

        State = NewState;
        Policy = PolicyImprovementUsingQ(Q, nActions);

    end

    disp(['Episode: ', num2str(e)]);
end

%% 
initialState = [1, 100];

display = 1 ;
epsilon = 0 ;
qPrediction = 0 ;
[VisitedStates, Actions, VisitedRewards] = GenerateEpisode(Plane, AllStates, AllActions, Policy, initialState, Goal, epsilon, display, qPrediction);
