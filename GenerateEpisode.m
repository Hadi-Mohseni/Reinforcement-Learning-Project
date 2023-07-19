% Generate an episode (sequence of states, actions, and rewards) for a given 
% plane navigation problem using a given policy and environment.
% Inputs:
% - Plane: The 2D plane represented as a matrix, where 1 indicates a free cell
%          and 0 indicates a barrier.
% - AllStates: Matrix containing all possible states (coordinates) in the plane.
% - AllActions: Matrix containing all possible actions.
% - Policy: A vector containing the chosen action for each state based on the policy.
% - initialStateActionPair: A pair containing the initial state [x, y] and initial
%                            action [dx, dy] for the episode.
% - Goal: The target/goal state that the agent aims to reach.
% - epsilon: Exploration parameter used for epsilon-greedy action selection.
% - display: A boolean flag to determine whether to visualize the episode during generation.
% - qPrediction: A boolean flag indicating whether the action-value function should
%                be predicted using the given policy (1) or not (0).

% Outputs:
% - States: A matrix containing the sequence of states visited in the episode.
% - Actions: A matrix containing the sequence of actions taken at each time step.
% - Rewards: A matrix containing the sequence of rewards received at each time step.


function [States, Actions, Rewards] = GenerateEpisode(Plane, ...
    AllStates, AllActions, Policy, initialStateActionPair, Goal, ...
    epsilon, display, qPrediction)
    
    % Generate an episode using the given policy from the initial state.
    % The episode consists of states, actions, and rewards encountered during the simulation.

    FinalTimeStep = 1e6; % Maximum number of time steps allowed in the episode.
    States = zeros(FinalTimeStep, 2); % Array to store states at each time step.
    Actions = zeros(FinalTimeStep, 1); % Array to store actions at each time step.
    Rewards = zeros(FinalTimeStep, 1); % Array to store rewards at each time step.

    isFinalState = 0; % Flag to indicate if the final state (goal state) is reached.
    t = 1; % Time step counter.

    States(t, :) = initialStateActionPair(1, [1 2]); % Set the initial state in the episode.

    while 1
        if display
            % Visualization (optional): Display the current state, goal, and plane with obstacles.
            Plane2 = Plane; % 1: free, 0: barrier
            Plane2(States(t, 1), States(t, 2)) = 3; % Mark the current state as '3' for visualization.
            Plane2(Goal(1), Goal(2) + 1) = 2; % Mark the goal state as '2' for visualization.
            imagesc(Plane2);
            title(['Time Step (' num2str(t) ')'], 'fontsize', 20);
            pause(0.1);
        end

        % Get the index of the current state in the list of all possible states.
        indexOfState = find(ismember(AllStates, States(t, :), 'row'));

        % Determine the action to take based on the epsilon-greedy policy.
        if rand > epsilon % Choose the action based on the learned policy with probability 1 - epsilon.
            At = Policy(indexOfState); % Select the action from the learned policy.
        else
            At = randi(size(AllActions, 1)); % Choose a random action with probability epsilon.
        end

        % If qPrediction is enabled and it's the first time step, set the initial action.
        if qPrediction == 1 && t == 1
            Actions(t, :) = initialStateActionPair(1, [3 4]);
        else
            Actions(t, :) = At; % Record the action taken at the current time step.
        end

        % Simulate the environment based on the current state and action.
        % Update the next state and reward based on the environment dynamics.
        [States(t + 1, :), Rewards(t + 1)] = Environment(AllStates, States(t, :), Actions(t, :), Goal);

        % Check if the next state is the goal state (reached the final state).
        if ismember(States(t + 1, :), Goal, 'row')
            isFinalState = 1; % Set the flag to indicate reaching the final state.
        end

        if isFinalState == 1
            if display
                % Visualization (optional): Display the final state if goal reached.
                Plane2 = Plane;
                Plane2(States(t + 1, 1), States(t + 1, 2) + 1) = 3;
                Plane2(Goal(1), Goal(2) + 1) = 2;
                imagesc(Plane2);
                title(['Time Step (' num2str(t) ')'], 'fontsize', 20);
                pause(0.1);
            end

            break; % Exit the episode generation loop when the goal is reached.
        end

        t = t + 1; % Increment the time step.
    end

    % Remove excess zeros from the arrays to get the actual episode data.
    States = States(1:t + 1, :);
    Actions = Actions(1:t + 1, :);
    Rewards = Rewards(1:t + 1, :);

end