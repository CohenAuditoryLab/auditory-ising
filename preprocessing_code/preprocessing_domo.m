function preprocessing_domo(tank)
% Takes in TANK as an argument - this is the path to the Domo data that came 
% from NeuronDecisions.m.  Produces files for the entire pre-processing
% pipeline, customized to the format of this data.

%% create CohenNeurons file
tank_data = load(tank);
tank_data = tank_data.g;

neurons = unique(tank_data(:,1));
num_neurons = length(neurons);

for i = 1:num_neurons
    n = neurons(i);
    CohenNeurons(i).ID = n;
    
    where_n = tank_data(:,1) == n;
    times = tank_data(where_n, 2);
    
    CohenNeurons(i).trials(1).spike_times = times;
end 

% then go to spike_train_processing
save('CohenNeurons.mat', 'CohenNeurons');

%% takes CohenNeurons.mat and pre-processes the data into an
% m-by-k-by-n matrix with m matrices (1 for each neuron), k rows of trials
% and n = 2001 columns for (1) TNR and (2000) times in spike train.

bin_length = 400;
trial_length = 8e6;

num_trials = 1;

% Pre-define binranges
binranges = linspace(0,trial_length,trial_length/bin_length+1);

% Preallocate mxkxn matrix with m neurons, k trials and n = num bins
% columns are spike train (we will remove last column at the end)
spike_array = zeros(num_neurons, num_trials, trial_length/bin_length+1);

% For each neuron...
for i = 1:num_neurons 
        % Create a spike train and store in spike_array
        t = CohenNeurons(i).trials(1); % .spike_times{1};
        if ~isempty(t.spike_times)
            counts = histc(t.spike_times, binranges);
        else
            counts = zeros(1, trial_length+1);
        end
        spike_array(i,1,1:end) = counts;  
end

% Remove last column of spike train (unwanted bin)
spike_array(:,:,end) = [];

% Save data
save('spike_trains.mat', 'spike_array');

%% Creates final neuron trains 

% since only one trial, reshape resulting matrix into flattened array 
spike_array = squeeze(spike_array);

% +1 when spiking, -1 when not spiking 
spike_array(spike_array > 0) = 1;
spike_array(spike_array == 0) = -1;

% reformat so that each row in neuron_trains is a cell array 
neuron_trains = cell(num_neurons, 1);
 
for k = 1:num_neurons
    neuron_trains{k} = spike_array(k,:);
end 

save('neuron_trains.mat', 'neuron_trains');

%% Move files to new folder 

%find index of dot 
dot = strfind(tank, '.');
%extract tank name
name = tank(1:dot-1);

%make a new directory
mkdir(name);

%move all the new files into that directory
movefile('CohenNeurons.mat', name);
movefile('neuron_trains.mat', name);
movefile('spike_trains.mat', name);
movefile(tank, name);

end 