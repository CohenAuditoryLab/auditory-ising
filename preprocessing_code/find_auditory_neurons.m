function find_auditory_neurons(tank_path, tank_name, behavioral_data)
%% TANK_PATH is the path to the tank, without ending / or file name 
%  TANK_NAME is the name of the .mat file containing the tank
%  BEHAVIORAL_DATA is the path to and name of the .mat file containing the 
%  stimulus onset times and behavioral indices 
%  Outputs .mat file containing auditory neurons, as well as 2 .mat files for
%  tank data of just auditory and just non-auditory neurons.  These tanks
%  are of the right format to be fed into 

%% Load behavioral data file

behavdata = load(behavioral_data);

stim_onset_data = behavdata.StimOnTime;
stim_type = behavdata.index;

%% Load tank data file 

tank_data = load([tank_path filesep tank_name]);
tank_data = tank_data.g;

neurons = unique(tank_data(:,1));
num_neurons = length(neurons);

%% Get stim onset times where stimulus was played (not 3 or 4) 

where_on = stim_type ~= 3 & stim_type ~= 4;
stim_onset = stim_onset_data(where_on);
stim_offset = stim_onset + 2000; % 2 seconds later

num_trials = length(stim_onset);

%% Find a reference time for when the stimulus is off

where_off = ~where_on;
stim_off_start = stim_onset_data(where_off);
stim_off_end = stim_off_start + 2000; % 2 seconds later

%% For each neuron, select data where stimulus is off. Store in cell array.

stimulus_off_all = cell(num_neurons, length(stim_off_end));

for i = 1:num_neurons
    % get spike times for that neuron
    neuron_times = tank_data(tank_data(:,1) == neurons(i), 2)/1e3; %convert to seconds
    for j = 1:length(stim_off_end)
        % reduce to spike times between start & end 
        neuron_times_off = neuron_times(neuron_times >= stim_off_start(j) & neuron_times <= stim_off_end(j));
        % store
        stimulus_off_all{i,j} = neuron_times_off;
    end 
end 

%% For each neuron, select data where stimulus is on. Store in cell array
% where rows are neurons and columns are trials.

stimulus_on_all = cell(num_neurons, num_trials);

%For each neuron...
for i = 1:num_neurons
    %get times for neuron
    neuron_times = tank_data(tank_data(:,1) == neurons(i), 2)/1e3 %convert to seconds;
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

%% Run t-test on each neuron to determine if it is auditory 
% compare each trial to pertaining data in stimulus_off_all

AudNeurons = [];

%For each neuron
for i = 1:num_neurons
    off_all = stimulus_off_all(i,:);
    on_all = stimulus_on_all(i,:);
    on = zeros(1, num_trials);
    off = zeros(1, length(off_all));
    %For each trial
    for j = 1:num_trials 
        %count number of spikes, store in vector 
        on(j) = length(on_all{j});
    end 
    for k = 1:length(off_all)
        off(k) = length(off_all{k});
    end 
    figure();
    histogram(on); hold on;
    histogram(off);
    legend({'On', 'Off'});
%     print(['spike_counts_neuron_' num2str(neurons(i))], '-dpng')
    
    pause(2);
    
    h = ttest2(on, off);
    if h == 1
        AudNeurons(end+1) = neurons(i);
    end
end 

close all;

%% Save auditory neurons in .mat file

% save([tank_path filesep 'auditory_neurons.mat'], 'AudNeurons');

%% Save tank containing only auditory and only non-auditory neurons 

mkdir([tank_path filesep 'Auditory']);
mkdir([tank_path filesep 'Non-Auditory']);

auditory_tank = [];
nonaud_tank = [];

for i = 1:num_neurons
    if ismember(neurons(i), AudNeurons)
        auditory_tank = vertcat(auditory_tank, tank_data(tank_data(:,1) == neurons(i), :));
    else 
        nonaud_tank = vertcat(nonaud_tank, tank_data(tank_data(:,1) == neurons(i), :));
    end 
end 

g = auditory_tank;
save([tank_path filesep 'Auditory' filesep 'auditory_tank.mat'], 'g');
g = nonaud_tank;
save([tank_path filesep 'Non-Auditory' filesep 'non_auditory_tank.mat'], 'g');
end 
