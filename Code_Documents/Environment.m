function [NewState , Reward] = Environment(AllStates , State , Action , Goal)

old_state = State(2) ;
power_of_action = mod(Action,10)*0.1 ;
if(power_of_action == 0)
    power_of_action = 1;
end

type_of_action = floor((Action-1)/10)+1 ;

% if type_of_action = 1 --> Putter selected    default distance :3
% if type_of_action = 2 --> Hybrids selected   default distance :6
% if type_of_action = 3 --> Irons selected     default distance :12
% if type_of_action = 4 --> Woods selected     default distance :18

switch(type_of_action)
    case 1
        % Putter selected
        default_distance = 3;
        precision = normrnd(1,0);

    case 2
        % Hybrids selected
        default_distance = 6;
        precision = normrnd(1,0.05);
    case 3
        % Irons selected
        default_distance = 12;
        precision = normrnd(1,0.15);
    case 4
        % Woods selected
        default_distance = 18;
        precision = normrnd(1,0.25);
end

wind_disturbance = normrnd(0,3);

d = ceil(power_of_action*default_distance*precision) + round((1-precision)*wind_disturbance);

new_state = abs( old_state -d  ) ;

% if (new_state == 0)
%     new_state = 1 ;
% end

NewState = [1 new_state];

if find(ismember(AllStates , NewState , 'row'))
    if ismember(NewState , Goal , 'row')
        Reward = +10;
    else
        Reward = -5;
    end
else
    Reward = -10 ;
    NewState = [1 100]; 
end
