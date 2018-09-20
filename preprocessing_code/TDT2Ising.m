function TDT2Ising(spike_data)
%% load TDT spike data 

spikes = load(spike_data);
spike_times = spikes.TimeStamps;
channels = spikes.Channel;
stim_on = spikes.StimOnTime * 1e3;

% % not indices 3 and 4 
% where_on = spikes.index ~= 3 & spikes.index ~= 4;
% spike_times = spike_times(where_on);
% channels = spike_times(where_on);
% stim_on = stim_on(where_on);

num_trials = size(spike_times,2);
num_neurons = 16;

%% concatenate each channel's data as a "neuron"

channel_concats = cell(16, 1);

for i = 1:num_trials
    % get time_stamps
    t = spike_times{i};
    % get stimulus on time, add to time stamps to uncenter around 0
    on = stim_on(i);
    t = t + on;
    % add to row in cell array corresponding to channel
    ch = channels{i};
    for j = 1:length(ch)
        current_ch = channel_concats{ch(j)};
        current_ch = horzcat(current_ch, t(j));
        channel_concats{ch(j)} = current_ch;
    end
end 

%% save in single-trial CohenNeurons.mat format 

%for each channel
for k = 1:16
    % get neuron ID
    CohenNeurons(k).ID = k;
    CohenNeurons(k).trials(1).spike_times = channel_concats{k};
end

save('CohenNeurons.mat', 'CohenNeurons');

%% takes CohenNeurons.mat and pre-processes the data into an
% m-by-k-by-n matrix with m matrices (1 for each neuron), k rows of trials
% and n = 2001 columns for (1) TNR and (2000) times in spike train.

trial_length = max(channel_concats{1});
disp(['Trial length: ' num2str(trial_length)]);
bin_length = 200;
disp(['Bin width: ' num2str(bin_length)]);

num_trials = 1;

% Pre-define binranges
binranges = linspace(0,trial_length,floor(trial_length/bin_length)+1);

% Preallocate mxkxn matrix with m neurons, k trials and n = num bins
% columns are spike train (we will remove last column at the end)
spike_array = zeros(num_neurons, num_trials, floor(trial_length/bin_length)+1);

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

% %% Move files to new folder 
% 
% %find index of dot 
% dot = strfind(tank, '.');
% %extract tank name
% name = tank(1:dot-1);
% 
% %make a new directory
% mkdir(name);
% 
% %move all the new files into that directory
% movefile('CohenNeurons.mat', name);
% movefile('neuron_trains.mat', name);
% movefile('spike_trains.mat', name);
% movefile(tank, name);

end 