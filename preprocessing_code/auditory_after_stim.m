function auditory_after_stim(auditory_data, behav_data)
% AUDITORY DATA is path to auditory tank
% BEHAV DATA is path to spike.mat file
%% Creates a CohenNeurons.mat structure with only auditory neurons separated
%  into trials, and spike times centered around stimulus onset.

%% load tank containing only auditory neurons
load(auditory_data);

neurons = unique(auditory_tank(:,1));
num_neurons = length(neurons);

auditory_tank(:,2) = auditory_tank(:,2);

%% load behavioral data to get stim onset times
behav = load(behav_data);

stim_onset = behav.StimOnTime * 1e3; %convert from s to ms
behav_type = behav.index;
tone_sep = behav.stDiff;

%% make sure this data is only for when stimulus is playing
where_on = behav_type ~= 3 & behav_type ~= 4;
stim_onset = stim_onset(where_on);
stim_offset = stim_onset + 2000;
behav_type = behav_type(where_on);
tone_sep = tone_sep(where_on);

num_trials = sum(where_on);

%% get time data 

stimulus_on_all = cell(num_neurons, num_trials);

%For each neuron...
for i = 1:num_neurons
    %get times for neuron
    neuron_times = auditory_tank(auditory_tank(:,1) == neurons(i), 2);
    %For each trial..
    for j = 1:num_trials
        %get times pertaining to trial (between on and offset)
        trial_on = stim_onset(j);
        trial_off = stim_offset(j);
        neuron_times_on = neuron_times(neuron_times >= trial_on & neuron_times <= trial_off);
        %store 
        stimulus_on_all{i, j} = neuron_times_on;
    end 
end 

%% for each neuron, want to make a structure that includes vectors of TNR,
%  monkey response, stim_on, spikes centered around stim_on (negative
%  before, positive after, 0 at)

trialIds = auditory_tank(:,1);

% for every neuron
for k = 1:num_neurons
    % get neuron ID
    CohenNeurons(k).ID = neurons(k);
    % get indices of trial info for neuron
    inds = find(trialIds == neurons(k));
    % for each trial
    for m = 1:num_trials
        % get TNR
        CohenNeurons(k).trials(m).TNR = tone_sep(m);
        % get monkey response
        CohenNeurons(k).trials(m).monkey_response = behav_type(m);
        % get stimulus onset time
        CohenNeurons(k).trials(m).stim_on = stim_onset(m);
        % center spikes times around stimOn time 
        spk_time = stimulus_on_all{k, m};
        spk_time = (spk_time - CohenNeurons(k).trials(m).stim_on);
        CohenNeurons(k).trials(m).spike_times = spk_time;
    end
end

% then go to spike_train_processing
save('CohenNeurons.mat', 'CohenNeurons');
end