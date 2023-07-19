% Environment - Golf Game Environment Simulator
%   [NewState, Reward] = Environment(AllStates, State, Action, Goal)
%
%   This function simulates the environment for a basic golf game. It takes the current
%   state, the selected action (representing the golf club and power used), and the goal
%   state. The function calculates the new state of the ball after taking the action
%   and computes the reward based on the success of the shot.
%
%   Inputs:
%       AllStates: An array containing all the possible states of the ball.
%       State: A 2-element array representing the current state of the ball [flag, position].
%       Action: An integer representing the selected action (golf club and power).
%       Goal: An array representing the goal state of the ball.
%
%   Outputs:
%       NewState: A 2-element array representing the new state of the ball after the action [flag, new_position].
%       Reward: A scalar value representing the reward earned based on the success of the shot.
%
function [NewState, Reward] = Environment(AllStates, State, Action, Goal)

% Extract the current position of the ball from the State array
old_state = State(2);

% Extract the power of the action (selected golf club) and its type
power_of_action = mod(Action, 10) * 0.1;
if (power_of_action == 0)
    power_of_action = 1; 
end
type_of_action = floor((Action - 1) / 10) + 1;

% Assign default distances and precision based on the type of action (golf club)
switch (type_of_action)
    case 1
        % Putter selected
        default_distance = 3;
        precision = normrnd(1, 0); % Mean of 1, no precision randomness.

    case 2
        % Hybrids selected
        default_distance = 6;
        precision = normrnd(1, 0.05); % Mean of 1, with 0.05 standard deviation.

    case 3
        % Irons selected
        default_distance = 12;
        precision = normrnd(1, 0.15); % Mean of 1, with 0.15 standard deviation.

    case 4
        % Woods selected
        default_distance = 18;
        precision = normrnd(1, 0.25); % Mean of 1, with 0.25 standard deviation.
end

% Generate a random wind disturbance using normal distribution with mean 0 and standard deviation of 3.
wind_disturbance = normrnd(0, 3);

% Calculate the new position of the ball after taking the action and considering the wind disturbance.
d = ceil(power_of_action * default_distance * precision) + round((1 - precision) * wind_disturbance);
new_state = abs(old_state - d);

% Set the NewState array to [1 new_state], where 1 represents the flag, and new_state is the updated position of the ball.
NewState = [1 new_state];

% Check if the NewState is one of the possible states in AllStates.
if find(ismember(AllStates, NewState, 'row'))
    % If the NewState is one of the possible states, check if it is the goal state.
    if ismember(NewState, Goal, 'row')
        % If NewState is the goal state, assign a positive reward of +10.
        Reward = +10;
    else
        % If NewState is not the goal state, assign a negative reward of -5.
        Reward = -5;
    end
else
    % If NewState is not one of the possible states, assign a negative reward of -10.
    Reward = -10;
    % Set NewState to [1 100] representing an out-of-bounds state.
    NewState = [1 100];
end
