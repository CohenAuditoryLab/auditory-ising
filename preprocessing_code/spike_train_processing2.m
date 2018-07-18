function spike_train_processing2(bin_length, trial_length)

% This function takes CohenNeurons.mat and pre-processes the data into an
% m-by-k-by-n matrix with m matrices (1 for each neuron), k rows of trials
% and n = 2001 columns for (1) TNR and (2000) times in spike train.

if ~exist('bin_length', 'var')
    bin_length = 2;
end

% Default trial length is 2000ms
if ~exist('trial_length', 'var')
    trial_length = 2000;
end

% Load CohenNeurons.mat
CohenNeurons = load('CohenNeurons.mat');
CohenNeurons = CohenNeurons.CohenNeurons;

% Number of neurons
num_neurons = size(CohenNeurons, 2);
num_trials = size(CohenNeurons(1).trials, 2);

% Preallocate mxkxn matrix with m neurons, k trials and n = 2000ms
% First column is TNR
% Next 2001 columns is spike train (we will remove 2001st column at the end)
spike_array = zeros(num_neurons, num_trials, trial_length/bin_length+2);

% Pre-define binranges from 0 to 2000ms
binranges = linspace(0,trial_length,trial_length/bin_length+1);

% For each neuron...
for i = 1:num_neurons
    % For each trial...
    for j = 1:num_trials
        t = CohenNeurons(i).trials(j);
        if ~isempty(t.spike_times)
            counts = histc(t.spike_times, binranges);
        else 
            counts = zeros(1, trial_length/bin_length+1);
        end 
        % Create a spike train and store in spike_array
        spike_array(i,j,2:end) = counts;
        % Record TNR
        spike_array(i,j,1) = CohenNeurons(i).trials(j).TNR;
    end
    % Print i
end

% Remove 2001st column of spike train (2002nd column of matrix)
spike_array(:,:,end) = [];

% Save data
save('spike_trains.mat', 'spike_array');
end