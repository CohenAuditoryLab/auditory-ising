% This file sorts the spike trains by TNR intensity and then concatenates
% them accordingly. The output is a 16x7 cell array with 16 rows of neurons
% and 7 columns of TNR intensities. Inside each cell is the concatenated
% spike train corresponding to all trials for a specific neuron with a
% specific TNR intensity.

% Load spike trains
spike_trains = load('spike_trains.mat');

spike_trains = spike_trains.spike_array;
% Remove first column (TNR intensity)
spike_trains(:,:,1) = [];

% All bins with spikes become +1
spike_trains(spike_trains > 0) = 1;
% All bins without spikes become -1
spike_trains(spike_trains == 0) = -1;

% Load TNR indices
TNR_index = load('TNR_index.mat');
TNR_index = TNR_index.ind;

% Number of TNR intensities, from 0 to 85
num_TNRs = length(unique(TNR_index));
num_neurons = size(spike_trains, 1);

% Preallocate cell array with 7 columns of TNR intensities
TNRsorted_trains = cell(1,num_TNRs);
TNRstimuli = cell(1,num_TNRs);

% For each TNR intensity...
for i = 1:num_TNRs
    % Find trials with TNR intensity i
    ind = (TNR_index == i);
    ind = ind(1:size(spike_trains, 2));
    % Store trials with TNR intensity i in cell column i
    TNRsorted_trains{1,i} = spike_trains(:,ind,:);
end

% Preallocate cell array with 16 rows of neurons and 7 columns of TNR intensities
sorted_trains = cell(num_neurons,num_TNRs);
sorted_stimuli = cell(num_neurons,num_TNRs);

% For each TNR intensity...
for i = 1:num_TNRs
    % Get TNR trials for that intensity
    TNRtrials = TNRsorted_trains{1,i};
    TNRtrials_stimuli = TNRstimuli{1,i};
    s2 = size(TNRtrials_stimuli, 1);
    s3 = size(TNRtrials_stimuli, 2);
    % For each neuron...
    for j = 1:num_neurons
        % Get specific trials for that neuron
        neurontrials = TNRtrials(j,:,:);
        s2 = size(neurontrials,2);
        s3 = size(neurontrials,3);
        neurontrials = permute(neurontrials, [1 3 2]);
        % Concatenate trains into 1 row vector
        neurontrials = reshape(neurontrials, 1, []);
        % Save concatenated train in cell array
        sorted_trains{j,i} = neurontrials;
    end
    % Print i
    i
end

save('sorted_trains.mat', 'sorted_trains');